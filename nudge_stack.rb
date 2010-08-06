# encoding: UTF-8
class NudgeStack < Array
  def initialize (value_type)
    @value_type = value_type
    @items_pushed = 0
  end
  
  def items_pushed
    @items_pushed
  end
  
  def << (item)
    @items_pushed += 1
    push item.to_s
  end
  
  alias depth length
  alias flush clear
  alias pop_string pop
  
  private :push, :pop
  public :pop_string
  
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
end

class ExecStack < NudgeStack
  
  alias << push
  alias pop_value pop
  undef pop_string
  
  public :<<, :pop_value
  
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
