if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end
io.stdout:setvbuf("no")
if arg[#arg] == "-debug" then require("mobdebug").start() end -- debug pas à pas