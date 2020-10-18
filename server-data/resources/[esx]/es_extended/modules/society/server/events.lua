-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code


on('esx:migrations:ensure', function(register)
  register('society')
end)

on('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)

  local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data
	}

	for i=1, #self.RegisteredSocieties, 1 do
		if self.RegisteredSocieties[i].name == name then
			found, self.RegisteredSocieties[i] = true, society
			break
		end
	end

	if not found then
		table.insert(self.RegisteredSocieties, society)
	end
end)

on('esx_society:getSocieties', function(cb)
	cb(self.RegisteredSocieties)
end)

on('esx_society:getSociety', function(name, cb)
	cb(self.GetSociety(name))
end)

onClient('esx_society:withdrawMoney', function(societyName, amount)
	local xPlayer = xPlayer.fromId(source)
	local society = self.GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		emit('esx_addonaccount:getSharedAccount', society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)
				xPlayer.showNotification(_U('society:have_withdrawn', ESX.Math.GroupDigits(amount)))
			else
				xPlayer.showNotification(_U('society:invalid_amount'))
			end
		end)
	else
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

onClient('esx_society:depositMoney', function(societyName, amount)
	local xPlayer = xPlayer.fromId(source)
	local society = self.GetSociety(societyName)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society.name then
		if amount > 0 and xPlayer.getMoney() >= amount then
			emit('esx_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeMoney(amount)
				xPlayer.showNotification(_U('society:have_deposited', ESX.Math.GroupDigits(amount)))
				account.addMoney(amount)
			end)
		else
			xPlayer.showNotification(_U('society:invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

onClient('esx_society:washMoney', function(society, amount)
	local xPlayer = xPlayer.fromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name == society then
		if amount and amount > 0 and account.money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)

			MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
				['@identifier'] = xPlayer.identifier,
				['@society'] = society,
				['@amount'] = amount
			}, function(rowsChanged)
				xPlayer.showNotification(_U('society:you_have', ESX.Math.GroupDigits(amount)))
			end)
		else
			xPlayer.showNotification(_U('society:invalid_amount'))
		end
	else
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

onClient('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = self.GetSociety(societyName)

	emit('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

onClient('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = self.GetSociety(societyName)

	emit('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

onRequest('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = self.GetSociety(societyName)

  if society then

		emit('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

onRequest('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function(results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = self.Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = self.Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = self.Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function(result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = self.Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = self.Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = self.Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

onRequest('esx_society:getJob', function(source, cb, society)
	local job = json.decode(json.encode(self.Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

onRequest('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = xPlayer.fromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = xPlayer.fromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				xTarget.showNotification(_U('society:you_have_been_hired', job))
			elseif type == 'promote' then
				xTarget.showNotification(_U('society:you_have_been_promoted'))
			elseif type == 'fire' then
				xTarget.showNotification(_U('society:you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

onRequest('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local xPlayer = xPlayer.fromId(source)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		if salary <= self.Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				self.Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xTarget = xPlayer.fromId(xPlayers[i])

					if xTarget.job.name == job and xTarget.job.grade == grade then
						xTarget.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(xPlayer.identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(xPlayer.identifier))
		cb()
	end
end)

onRequest('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = xPlayer.fromId(xPlayers[i])
		table.insert(players, {
			source = xPlayer.source,
			identifier = xPlayer.identifier,
			name = xPlayer.name,
			job = xPlayer.job
		})
	end

	cb(players)
end)

onRequest('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = self.GetSociety(societyName)

	emit('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

onRequest('esx_society:isBoss', function(source, cb, job)
	cb(self.isPlayerBoss(source, job))
end)

on('esx:migrations:done', function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		self.Jobs[result[i].name] = result[i]
		self.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		self.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)
