--[[ Creates provider for master or specialist nets. ]]--

-- Imports
require 'xlua'
require 'nn'
dofile 'provider.lua'

-- Parameters
cmd = torch.CmdLine()
cmd:text('Create provider')
cmd:text()
cmd:text('Options')
cmd:option('-target', 'specialists', 'Target should be specialists or master')
cmd:option('-path', '/mnt', 'Path to save the provider')
cmd:option('-scores', 'master/master_scores.t7', 'Path to master scores')
cmd:option('-backend', 'cudnn')
cmd:text()

-- Parse input params
local opt = cmd:parse(arg)

-- Import necessary modules
if opt.backend == 'cudnn' then
	require 'cunn'
	require 'cudnn'
	require 'cutorch'
	cudnn.fastest, cudnn.benchmark = true, true
end

if opt.backpend == 'cunn' then
	require 'cunn'
	require 'cutorch'
end

-- Master provider creation
if opt.target == 'master' then
	provider = Provider()
	provider:normalize()
	-- Change permissions on temp mnt/ directory on AWS
	os.execute('sudo chmod 777 ' .. opt.path)
	torch.save(opt.path .. '/master_provider.t7', provider)
end

-- Specialist provider creation (same but with scores)
if opt.target == 'specialists' then
	scores = torch.load(opt.scores)
	provider = Provider(scores)
	provider:normalize()
	-- Change permissions on temp mnt/ directory on AWS
	os.execute('sudo chmod 777 ' .. opt.path)
	torch.save(opt.path .. '/specialist_provider.t7', provider)
end
