require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "code object:" do
  describe "listing:" do
    it "should default to an empty string"
    
    
    describe "point counter" do
      it "should return 0 for an empty program"
      
      it "should return 1 for a single-line program"
      
      it "should return the number of lines"
      
      it "should ignore blank lines"
      
      it "should ignore comment lines beginning with '#'"
    end
    
    describe "unwrap_block" do
      it "should return an empty array for a one-point block"
      
      it "should return a code object for each line of a 'flat' block"
      
      it "should return only the base points in the block"
      
      it "should fail when a 'block' line doesn't start multiline code"
      
      it "should raise an exception when the indentation is wrong"
      
      it "should raise an exception if passed an empty block"
      
    end
    
    describe "syntax validation" do      
      it "should validate an empty code string"
            
      describe "one-line programs" do        
        it "should validate a one-line program including only a literal line"
        it "should validate a one-line program including only an erc line"
        it "should validate a one-line program including only an instruction line"
        it "should validate a one-line program including only a binding line"
        it "should validate a one-line program including only a block line"
        
        
        
        
      end
    end
  end
  
  
  describe "contents" do
    it "should default to empty list in new Code objects"
    
    it "should be settable to a Literal, which is stored as an array"
    
    it "should be settable to an Erc"
    
    it "should be settable to a Code object"
    
    it "should be settable to a Channel object"
    
    it "should be settable to an OpCode"
    
    it "should be settable to an array containing OpCodes"
    
    it "should be settable to a array of OpCode, Literal, Code, Erc or Channel objects"
    
    describe "should not be initializable to anything else" do
      before(:each) do
        @msg = "Unrecognized class appears in Code.contents"
      end
      
      it "should fail if it's an atom but not one of the allowed atoms"
      
      it "should fail if it's an Array containing a disallowed atom" 
      
      it "should fail if it's an empty Array"
    end
    
    describe "be settable to only the right stuff" do
      before(:each) do
        @msg = "Unrecognized class appears in Code.contents"
      end
      
      it "shouldn't fail for setting with accepted stuff"
      
      it "should fail if it's an atom but not one of the allowed atoms"
      
      it "shouldn't fail if it's an Array containing allowed atoms"
      
      it "should fail if it's an Array containing a disallowed atom"
      
      it "should fail if it's an empty Array"
    end
    
    describe "splitting" do
      it "should produce an empty list if the Code contains nothing"
      
      it "should produce a list with one entry when the Code contains an atom" 
      
      it "should produce a list of the top-level entries when it contains multiple items"
    end
    
    describe "points" do
      it "should return 1 when called by a Code with no contents" 
      
      it "should return 1 + the number of elements in the root's contents tree"
    end
    
    describe "nth_point" do
      it "should return the Code itself when called with n=1"
      
      it "should raise an ArgumentError when called with n not in [1,Code.points]"
      
      it "should return the entirety of the point specified when n>1"
    end
    
    
    describe "types" do
      it "should return an empty list for pure Code trees"
      
      it "should return a list of the types of Leaves if that's all there is"
      
      it "should return a list of the types of all leaves"
      
    end
    
    describe "I/O modes" do
      it "should allow YAML to be used to create new contents"
      it "should output YAML that can be re-read to create a duplicate"
      it "should provide a simple shorthand to quickly create code trees"
      
    end
    
    
    
    describe "leaf_count" do
      it "should return a count of the non-Code elements of the contents"
    end
    
    describe "point_list" do
      it "should return an array that includes the entirety of every point"
    end
    
    describe "point_index" do
      it "should return a hash with key=point number, value=address of point in code"
    end
    
    describe "delete_point" do
      it "should delete the entire subtree with the appropriate point number"
    end
    
    describe "replace_point" do
      it "should replace the entire subtree with the appropriate point number"
    end
    
    
  end
end