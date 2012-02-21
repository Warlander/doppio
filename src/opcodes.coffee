class Opcode
  constructor: (@name, @execute=((rs) ->), @byte_count=0) ->

  take_args: (code_array) ->
    @args = [code_array.get_uint(1) for i in [0...@byte_count]]

class LocalVarOpcode extends Opcode
  take_args: (code_array) ->
    @var_num = code_array.get_uint(1)

class FieldOpcode extends Opcode
  take_args: (code_array) ->
    @field_spec = code_array.get_uint(1)
    @descriptor = code_array.get_uint(1)

class ClassOpcode extends Opcode
  take_args: (code_array, constant_pool) ->
    @class_ref = code_array.get_uint(2)
    @class = constant_pool.get(@class_ref).deref()

class InvokeOpcode extends Opcode
  take_args: (code_array, constant_pool) ->
    @method_spec_ref = code_array.get_uint(2)
    # invokeinterface has two redundant bytes
    code_array.index += 2 if @name == 'invokeinterface'
    @method_spec = constant_pool.get(@method_spec_ref).deref()

class LoadOpcode extends Opcode
  take_args: (code_array, constant_pool) ->
    @constant_ref = code_array.get_uint(@byte_count)
    @constant = constant_pool.get @constant_ref

class BranchOpcode extends Opcode
  take_args: (code_array) ->
    @offset = code_array.get_uint(2)

@opcodes = {
  00: new Opcode 'nop'
  01: new Opcode 'aconst_null'
  02: new Opcode 'iconst_m1'
  03: new Opcode 'iconst_0', (rs) -> rs.push 0
  04: new Opcode 'iconst_1', (rs) -> rs.push 1
  05: new Opcode 'iconst_2', (rs) -> rs.push 2
  06: new Opcode 'iconst_3', (rs) -> rs.push 3
  07: new Opcode 'iconst_4', (rs) -> rs.push 4
  08: new Opcode 'iconst_5', (rs) -> rs.push 5
  09: new Opcode 'lconst_0'
  10: new Opcode 'lconst_1'
  11: new Opcode 'fconst_0'
  12: new Opcode 'fconst_1'
  13: new Opcode 'fconst_2'
  14: new Opcode 'dconst_0'
  15: new Opcode 'dconst_1'
  16: new Opcode 'bipush'
  17: new Opcode 'sipush'
  18: new LoadOpcode 'ldc'
  19: new LoadOpcode 'ldc_w', 2
  20: new LoadOpcode 'ldc2_w', 2
  21: new LocalVarOpcode 'iload'
  22: new LocalVarOpcode 'lload'
  23: new LocalVarOpcode 'fload'
  24: new LocalVarOpcode 'dload'
  25: new LocalVarOpcode 'aload'
  26: new Opcode 'iload_0', (rs) -> rs.push(rs.cl(0))
  27: new Opcode 'iload_1', (rs) -> rs.push(rs.cl(1))
  28: new Opcode 'iload_2', (rs) -> rs.push(rs.cl(2))
  29: new Opcode 'iload_3'
  30: new Opcode 'lload_0'
  31: new Opcode 'lload_1'
  32: new Opcode 'lload_2'
  33: new Opcode 'lload_3'
  34: new Opcode 'fload_0'
  35: new Opcode 'fload_1'
  36: new Opcode 'fload_2'
  37: new Opcode 'fload_3'
  38: new Opcode 'dload_0'
  39: new Opcode 'dload_1'
  40: new Opcode 'dload_2'
  41: new Opcode 'dload_3'
  42: new Opcode 'aload_0', (rs) -> rs.push(rs.cl(0))
  43: new Opcode 'aload_1'
  44: new Opcode 'aload_2'
  45: new Opcode 'aload_3'
  46: new Opcode 'iaload'
  47: new Opcode 'laload'
  48: new Opcode 'faload'
  49: new Opcode 'daload'
  50: new Opcode 'aaload'
  51: new Opcode 'baload'
  52: new Opcode 'caload'
  53: new Opcode 'saload'
  54: new LocalVarOpcode 'istore'
  55: new LocalVarOpcode 'lstore'
  56: new LocalVarOpcode 'fstore'
  57: new LocalVarOpcode 'dstore'
  58: new LocalVarOpcode 'astore'
  59: new Opcode 'istore_0', (rs) -> rs.put_cl(0,rs.pop())
  60: new Opcode 'istore_1', (rs) -> rs.put_cl(1,rs.pop())
  61: new Opcode 'istore_2', (rs) -> rs.put_cl(2,rs.pop())
  62: new Opcode 'istore_3', (rs) -> rs.put_cl(3,rs.pop())
  63: new Opcode 'lstore_0'
  64: new Opcode 'lstore_1'
  65: new Opcode 'lstore_2'
  66: new Opcode 'lstore_3'
  67: new Opcode 'fstore_0'
  68: new Opcode 'fstore_1'
  69: new Opcode 'fstore_2'
  70: new Opcode 'fstore_3'
  71: new Opcode 'dstore_0'
  72: new Opcode 'dstore_1'
  73: new Opcode 'dstore_2'
  74: new Opcode 'dstore_3'
  75: new Opcode 'astore_0'
  76: new Opcode 'astore_1'
  77: new Opcode 'astore_2'
  78: new Opcode 'astore_3'
  79: new Opcode 'iastore'
  80: new Opcode 'lastore'
  81: new Opcode 'fastore'
  82: new Opcode 'dastore'
  83: new Opcode 'aastore'
  84: new Opcode 'bastore'
  85: new Opcode 'castore'
  86: new Opcode 'sastore'
  87: new Opcode 'pop'
  88: new Opcode 'pop2'
  089: new Opcode 'dup'
  090: new Opcode 'dup_x1'
  091: new Opcode 'dup_x2'
  092: new Opcode 'dup2'
  093: new Opcode 'dup2_x1'
  094: new Opcode 'dup2_x2'
  095: new Opcode 'swap'
  096: new Opcode 'iadd', (rs) -> rs.push(rs.pop()+rs.pop())
  097: new Opcode 'ladd'
  098: new Opcode 'fadd'
  099: new Opcode 'dadd'
  100: new Opcode 'isub'
  101: new Opcode 'lsub'
  102: new Opcode 'fsub'
  103: new Opcode 'dsub'
  104: new Opcode 'imul'
  105: new Opcode 'lmul'
  106: new Opcode 'fmul'
  107: new Opcode 'dmul'
  108: new Opcode 'idiv'
  109: new Opcode 'ldiv'
  110: new Opcode 'fdiv'
  111: new Opcode 'ddiv'
  112: new Opcode 'irem'
  113: new Opcode 'lrem'
  114: new Opcode 'frem'
  115: new Opcode 'drem'
  116: new Opcode 'ineg'
  117: new Opcode 'lneg'
  118: new Opcode 'fneg'
  119: new Opcode 'dneg'
  120: new Opcode 'ishl'
  121: new Opcode 'lshl'
  122: new Opcode 'ishr'
  123: new Opcode 'lshr'
  124: new Opcode 'iushr'
  125: new Opcode 'lushr'
  126: new Opcode 'iand'
  127: new Opcode 'land'
  128: new Opcode 'ior'
  129: new Opcode 'lor'
  130: new Opcode 'ixor'
  131: new Opcode 'lxor'
  132: new Opcode 'iinc', 2
  133: new Opcode 'i2l'
  134: new Opcode 'i2f'
  135: new Opcode 'i2d'
  136: new Opcode 'l2i'
  137: new Opcode 'l2f'
  138: new Opcode 'l2d'
  139: new Opcode 'f2i'
  140: new Opcode 'f2l'
  141: new Opcode 'f2d'
  142: new Opcode 'd2i'
  143: new Opcode 'd2l'
  144: new Opcode 'd2f'
  145: new Opcode 'i2b'
  146: new Opcode 'i2c'
  147: new Opcode 'i2s'
  148: new Opcode 'lcmp'
  149: new Opcode 'fcmpl'
  150: new Opcode 'fcmpg'
  151: new Opcode 'dcmpl'
  152: new Opcode 'dcmpg'
  153: new BranchOpcode 'ifeq'
  154: new BranchOpcode 'ifne'
  155: new BranchOpcode 'iflt'
  156: new BranchOpcode 'ifge'
  157: new BranchOpcode 'ifgt'
  158: new BranchOpcode 'ifle'
  159: new BranchOpcode 'if_icmpeq'
  160: new BranchOpcode 'if_icmpne'
  161: new BranchOpcode 'if_icmplt'
  162: new BranchOpcode 'if_icmpge'
  163: new BranchOpcode 'if_icmpgt'
  164: new BranchOpcode 'if_icmple'
  165: new BranchOpcode 'if_acmpeq'
  166: new BranchOpcode 'if_acmpne'
  167: new Opcode 'goto'
  168: new Opcode 'jsr'
  169: new LocalVarOpcode 'ret'
  170: new Opcode 'tableswitch'
  171: new Opcode 'lookupswitch'
  172: new Opcode 'ireturn'
  173: new Opcode 'lreturn'
  174: new Opcode 'freturn'
  175: new Opcode 'dreturn'
  176: new Opcode 'areturn'
  177: new Opcode 'return'
  178: new FieldOpcode 'getstatic'
  179: new FieldOpcode 'putstatic'
  180: new FieldOpcode 'getfield'
  181: new FieldOpcode 'putfield'
  182: new InvokeOpcode 'invokevirtual'
  183: new InvokeOpcode 'invokespecial'
  184: new InvokeOpcode 'invokestatic'
  184: new InvokeOpcode 'invokeinterface'
  187: new ClassOpcode 'new'
  188: new Opcode 'newarray'
  189: new ClassOpcode 'anewarray'
  190: new Opcode 'arraylength'
  191: new Opcode 'athrow'
  192: new ClassOpcode 'checkcast'
  193: new ClassOpcode 'instanceof'
  194: new Opcode 'monitorenter'
  195: new Opcode 'monitorexit'
  196: new Opcode 'wide'
  197: new Opcode 'multianewarray'
  198: new BranchOpcode 'ifnull'
  199: new BranchOpcode 'ifnonnull'
  200: new Opcode 'goto_w'
  201: new Opcode 'jsr_w'
}

module?.exports = @opcodes
