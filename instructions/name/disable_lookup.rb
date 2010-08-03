# encoding: UTF-8
class NameDisableLookup < NudgeInstruction
  def process
    @executable.instance_variable_set(:@allow_lookup, false)
  end
end
