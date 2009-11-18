INTEGER instructions

INTEGER.%:           IntModuloInstruction
INTEGER.*:           IntMultiplyInstruction
INTEGER.+:           IntAddInstruction
INTEGER.-:           IntSubtractInstruction
INTEGER./:           IntDivideInstruction
INTEGER.<:           IntLessThanQInstruction
INTEGER.=:           IntEqualQInstruction
INTEGER.>:           IntGreaterThanQInstruction
INTEGER.DEFINE:      IntDefineInstruction
INTEGER.DUP:         IntDuplicateInstruction
INTEGER.FLUSH:       IntFlushInstruction
INTEGER.FROMBOOLEAN: IntFromBoolInstruction
INTEGER.FROMFLOAT:   IntFromFloatInstruction
INTEGER.MAX:         IntMaxInstruction
INTEGER.MIN:         IntMinInstruction
INTEGER.POP:         IntPopInstruction
INTEGER.RAND:        IntRandomInstruction
INTEGER.ROT:         IntRotateInstruction
INTEGER.SHOVE:       IntShoveInstruction
INTEGER.STACKDEPTH:  IntDepthInstruction
INTEGER.SWAP:        IntSwapInstruction
INTEGER.YANK:        IntYankInstruction
INTEGER.YANKDUP:     IntYankdupInstruction

                     IntAbsInstruction
                     IntIfInstruction
                     IntNegativeInstruction

FLOAT instructions

FLOAT.%:             FloatModuloInstruction
FLOAT.*:             FloatMultiplyInstruction
FLOAT.+:             FloatAddInstruction
FLOAT.-:             FloatSubtractInstruction
FLOAT./:             FloatDivideInstruction
FLOAT.<:             FloatLessThanQInstruction
FLOAT.=:             FloatEqualQInstruction
FLOAT.>:             FloatGreaterThanQInstruction
FLOAT.COS:           FloatCosineInstruction
FLOAT.DEFINE:        FloatDefineInstruction
FLOAT.DUP:           FloatDuplicateInstruction
FLOAT.FLUSH:         FloatFlushInstruction
FLOAT.FROMBOOLEAN:   FloatFromBoolInstruction
FLOAT.FROMINTEGER:   FloatFromIntInstruction
FLOAT.MAX:           FloatMaxInstruction
FLOAT.MIN:           FloatMinInstruction
FLOAT.POP:           FloatPopInstruction
FLOAT.RAND:          FloatRandomInstruction
FLOAT.ROT:           FloatRotateInstruction
FLOAT.SHOVE:         FloatShoveInstruction
FLOAT.SIN:           FloatSineInstruction
FLOAT.STACKDEPTH:    FloatDepthInstruction
FLOAT.SWAP:          FloatSwapInstruction
FLOAT.TAN:           FloatTangentInstruction
FLOAT.YANK:          FloatYankInstruction
FLOAT.YANKDUP:       FloatYankdupInstruction
                     
                     FloatAbsInstruction
                     FloatIfInstruction
                     FloatNegativeInstruction
                     FloatPowerInstruction
                     FloatSqrtInstruction

BOOLEAN instructions

BOOLEAN.=:           BoolEqualQInstruction
BOOLEAN.AND:         BoolAndInstruction
BOOLEAN.DEFINE:      BoolDefineInstruction
BOOLEAN.DUP:         BoolDuplicateInstruction
BOOLEAN.FLUSH:       BoolFlushInstruction
BOOLEAN.FROMFLOAT:   BoolFromFloatInstruction
BOOLEAN.FROMINTEGER: BoolFromIntInstruction
BOOLEAN.NOT:         BoolNotInstruction
BOOLEAN.OR:          BoolOrInstruction
BOOLEAN.POP:         BoolPopInstruction
BOOLEAN.RAND:        BoolRandomInstruction
BOOLEAN.ROT:         BoolRotateInstruction
BOOLEAN.SHOVE:       BoolShoveInstruction
BOOLEAN.STACKDEPTH:  BoolDepthInstruction
BOOLEAN.SWAP:        BoolSwapInstruction
BOOLEAN.YANK:        BoolYankInstruction
BOOLEAN.YANKDUP:     BoolYankdupInstruction

                     BoolXorInstruction



NAME instructions

NAME.=:              
NAME.DUP:            NameDupInstruction
NAME.FLUSH:          NameFlushInstruction
NAME.POP:            NamePopInstruction
NAME.QUOTE: 
NAME.RAND: 
NAME.RANDBOUNDNAME: 
NAME.ROT:            NameRotInstruction
NAME.SHOVE:          NameShoveInstruction
NAME.STACKDEPTH:     NameDepthInstruction
NAME.SWAP:           NameSwapInstruction
NAME.YANK:           NameYankInstruction
NAME.YANKDUP:        NameYankdupInstruction



EXEC instructions

EXEC.=:              ExecEqualQInstruction
EXEC.DEFINE:         ExecDefineInstruction
EXEC.DO*COUNT:       ExecDoCountInstruction
EXEC.DO*RANGE:       ExecDoRangeInstruction
EXEC.DO*TIMES:       ExecDoTimesInstruction
EXEC.DUP:            ExecDuplicateInstruction
EXEC.FLUSH:          ExecFlushInstruction
EXEC.IF:             ExecIfInstruction
EXEC.K:              ExecKInstruction
EXEC.POP:            ExecPopInstruction
EXEC.ROT:            ExecRotateInstruction
EXEC.S:              ExecSInstruction
EXEC.SHOVE:          ExecShoveInstruction
EXEC.STACKDEPTH:     ExecDepthInstruction
EXEC.SWAP:           ExecSwapInstruction
EXEC.Y:              ExecYInstruction
EXEC.YANK:           ExecYankInstruction
EXEC.YANKDUP:        ExecYankdupInstruction



CODE instructions

CODE.=: 
CODE.APPEND: 
CODE.ATOM: 
CODE.CAR: 
CODE.CDR: 
CODE.CONS: 
CODE.CONTAINER: 
CODE.CONTAINS: 
CODE.DEFINE: 
CODE.DEFINITION: 
CODE.DISCREPANCY: 
CODE.DO: 
CODE.DO*: 
CODE.DO*COUNT:
CODE.DO*RANGE: 
CODE.DO*TIMES: 
CODE.DUP: 
CODE.EXTRACT: 
CODE.FLUSH: 
CODE.FROMBOOLEAN: 
CODE.FROMFLOAT: 
CODE.FROMINTEGER: 
CODE.FROMNAME: 
CODE.IF: 
CODE.INSERT: 
CODE.INSTRUCTIONS: 
CODE.LENGTH: 
CODE.LIST: 
CODE.MEMBER: 
CODE.NOOP: 
CODE.NTH: 
CODE.NTHCDR: 
CODE.NULL: 
CODE.POP: 
CODE.POSITION: 
CODE.QUOTE: 
CODE.RAND: 
CODE.ROT: 
CODE.SHOVE: 
CODE.SIZE: 
CODE.STACKDEPTH: 
CODE.SUBST: 
CODE.SWAP: 
CODE.YANK: 
CODE.YANKDUP: 