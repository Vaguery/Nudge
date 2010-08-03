# encoding: UTF-8
class NudgeStack < Array
  def initialize (value_type)
    @value_type = value_type
  end
  
  def << (item)
    push item.to_s
  end
  
  def pop_string
    pop
  end
  
  def pop_value
    if value = pop
      value.send(:"to_#{@value_type}")
    end
  end
  
  def shove (n)
    return if length < 2
    
    case
      when n <= 0
      when n >= length then unshift(pop)
      else insert(length - 1 - n, pop)
    end
  end
  
  def yank (n)
    return if length < 2
    
    case
      when n <= 0
      when n >= length then push(shift)
      else push(delete_at(length - 1 - n))
    end
  end
  
  def yankdup (n)
    return if length < 2
    
    case
      when n <= 0 then push(last)
      when n >= length then push(first)
      else push(self[length - 1 - n])
    end
  end
  
  private :push, :pop
end

class ExecStack < NudgeStack
  def << (item)
    push item
  end
  
  def pop_value
    pop
  end
  
  undef pop_string
  
  def yankdup (n)
    return if length < 2
    
    case
      when n <= 0 then push(last.dup)
      when n >= length then push(first.dup)
      else push(self[length - 1 - n].dup)
    end
  end
end

class ErrorStack < NudgeStack
  def << (error)
    push "#{error.class.name.split('::').last}: #{error.message}"
  end
  
  undef pop_value
end
