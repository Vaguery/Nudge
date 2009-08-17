# this is more like what I want in the long term: a DSL for instruction definition


instruction :int_subtract do
  needs :int, 2
  
  pop @arg2 from :int
  pop @arg1 from :int
  
  @result = @arg1 + @arg2
  
  push @result onto :int
end


instruction :bool_swap do
  needs :bool, 2
  
  pop @arg2 from :bool
  pop @arg1 from :bool
  
  push @arg1 onto :bool
  push @arg2 onto :bool
end


instruction :code_flush do
  needs :code
  
  flush stack :code
end


instruction :code_if do
  needs :bool, 1
  needs :code, 2
  
  pop @arg1 from :bool
  pop @arg2 from :code
  pop @arg3 from :code
  
  if @arg1 then
    push @arg3 onto :exec
  else
    push @arg2 onto :exec
  end
end


instruction :image_yank do
  needs :image
  needs :int, 1
  
  pop @arg1 from :int
  
  yank @result from stack :image position @arg1
    # assuming 'yank' does normalization of argument quietly
  push @result onto stack :image
end


# Trickier dynamic definitions where the requirements are not as obvious:

instruction :vector_fromfloat do
  needs :int, 1
  needs :float
  
  pop @howmany from :int
    #number of elements to slice
  slice_with_repeat @nums from :float taking @howmany
  
  @result = Vector.new(@nums)
  
  push @result onto :vector
end