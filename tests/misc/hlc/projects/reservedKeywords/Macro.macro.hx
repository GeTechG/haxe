import haxe.macro.Context;

using haxe.macro.Tools;

class Macro {
	public static function build() {
		var fields = Context.getBuildFields();
		var keywords = [
			"auto", "bool", "break", "case", "char", "const", "continue", "default", "do", "double", "else", "enum", "extern", "float", "for", "goto",
			"if", "int", "long", "register", "return", "short", "signed", "sizeof", "static", "struct", "switch", "typedef", "union", "unsigned",
			"void", "volatile", "while",
			// Values
			"NULL", "true", "false",
			// MS specific
			"asm", "dllimport2", "dllexport2", "naked2", "thread2",
			// reserved by HLC
			"t",
			// GCC
			"typeof",
			// C11
			"_Alignas", "_Alignof", "_Atomic", "_Bool", "_Complex", "_Generic", "_Imaginary", "_Noreturn", "_Static_assert", "_Thread_local", "_Pragma",
			"inline", "restrict", "_restrict",
			// Macros of the C standard library headers included by hl.h and hlc.h (ISO C, POSIX, glibc, Bionic)
			"alloca", "ARG_MAX", "be16toh", "be32toh", "be64toh", "BIG_ENDIAN", "BIONIC_MULTIBYTE_RESULT_ILLEGAL_SEQUENCE",
			"BIONIC_MULTIBYTE_RESULT_INCOMPLETE_SEQUENCE", "BIONIC_MULTIBYTE_RESULT_NO_BYTES_CONSUMED", "BUFSIZ", "BYTE_ORDER",
			"CHAR_BIT", "CHAR_MAX", "CHAR_MIN", "DBL_DECIMAL_DIG", "DBL_DIG", "DBL_EPSILON", "DBL_HAS_SUBNORM", "DBL_MANT_DIG", "DBL_MAX",
			"DBL_MAX_10_EXP", "DBL_MAX_EXP", "DBL_MIN", "DBL_MIN_10_EXP", "DBL_MIN_EXP", "DBL_TRUE_MIN", "DECIMAL_DIG", "EDOM", "EILSEQ",
			"EOF", "EOVERFLOW", "ERANGE", "errno", "EXIT_FAILURE", "EXIT_SUCCESS", "FD_CLR", "FD_ISSET", "FD_SET", "FD_SETSIZE",
			"FD_ZERO", "FILENAME_MAX", "FLT_DECIMAL_DIG", "FLT_DIG", "FLT_EPSILON", "FLT_EVAL_METHOD", "FLT_HAS_SUBNORM", "FLT_MANT_DIG",
			"FLT_MAX", "FLT_MAX_10_EXP", "FLT_MAX_EXP", "FLT_MIN", "FLT_MIN_10_EXP", "FLT_MIN_EXP", "FLT_RADIX", "FLT_ROUNDS",
			"FLT_TRUE_MIN", "FOPEN_MAX", "fpclassify", "FP_FAST_FMA", "FP_FAST_FMAF", "FP_FAST_FMAL", "FP_ILOGB0", "FP_ILOGBNAN",
			"FP_INFINITE", "FP_NAN", "FP_NORMAL", "FP_SUBNORMAL", "FP_ZERO", "fropen", "fwopen", "GID_MAX", "HOST_NAME_MAX", "htobe16",
			"htobe32", "htobe64", "htole16", "htole32", "htole64", "HUGE_VAL", "HUGE_VALF", "HUGE_VALL", "INFINITY", "INT16_C",
			"INT16_MAX", "INT16_MIN", "INT32_C", "INT32_MAX", "INT32_MIN", "INT64_C", "INT64_MAX", "INT64_MIN", "INT8_C", "INT8_MAX",
			"INT8_MIN", "INT_FAST16_C", "INT_FAST16_MAX", "INT_FAST16_MIN", "INT_FAST32_C", "INT_FAST32_MAX", "INT_FAST32_MIN",
			"INT_FAST64_C", "INT_FAST64_MAX", "INT_FAST64_MIN", "INT_FAST8_C", "INT_FAST8_MAX", "INT_FAST8_MIN", "INT_LEAST16_C",
			"INT_LEAST16_MAX", "INT_LEAST16_MIN", "INT_LEAST32_C", "INT_LEAST32_MAX", "INT_LEAST32_MIN", "INT_LEAST64_C",
			"INT_LEAST64_MAX", "INT_LEAST64_MIN", "INT_LEAST8_C", "INT_LEAST8_MAX", "INT_LEAST8_MIN", "INT_MAX", "INTMAX_C", "INTMAX_MAX",
			"INTMAX_MIN", "INT_MIN", "INTPTR_C", "INTPTR_MAX", "INTPTR_MIN", "IOV_MAX", "isfinite", "isgreater", "isgreaterequal",
			"isinf", "isless", "islessequal", "islessgreater", "isnan", "isnormal", "isunordered", "L_ctermid", "LDBL_DECIMAL_DIG",
			"LDBL_DIG", "LDBL_EPSILON", "LDBL_HAS_SUBNORM", "LDBL_MANT_DIG", "LDBL_MAX", "LDBL_MAX_10_EXP", "LDBL_MAX_EXP", "LDBL_MIN",
			"LDBL_MIN_10_EXP", "LDBL_MIN_EXP", "LDBL_TRUE_MIN", "le16toh", "le32toh", "le64toh", "LINE_MAX", "LINK_MAX", "LITTLE_ENDIAN",
			"LLONG_MAX", "LLONG_MIN", "LOGIN_NAME_MAX", "LONG_BIT", "LONG_LONG_MAX", "LONG_LONG_MIN", "LONG_MAX", "LONG_MIN", "L_tmpnam",
			"M_1_PI", "M_2_PI", "M_2_SQRTPI", "MATH_ERREXCEPT", "math_errhandling", "MATH_ERRNO", "MAX_CANON", "MAXFLOAT", "MAX_INPUT",
			"MB_CUR_MAX", "M_BIONIC_SET_HEAP_TAGGING_LEVEL", "M_BIONIC_ZERO_INIT", "MB_LEN_MAX", "M_CACHE_COUNT_MAX", "M_CACHE_SIZE_MAX",
			"M_DECAY_TIME", "M_E", "M_HEAP_TAGGING_LEVEL_ASYNC", "M_HEAP_TAGGING_LEVEL_NONE", "M_HEAP_TAGGING_LEVEL_SYNC",
			"M_HEAP_TAGGING_LEVEL_TBI", "M_LN10", "M_LN2", "M_LOG10E", "M_LOG2E", "M_LOG_STATS", "M_MEMTAG_TUNING",
			"M_MEMTAG_TUNING_BUFFER_OVERFLOW", "M_MEMTAG_TUNING_UAF", "M_PI", "M_PI_2", "M_PI_4", "M_PURGE", "M_PURGE_ALL", "M_SQRT1_2",
			"M_SQRT2", "M_THREAD_DISABLE_MEM_INIT", "M_TSDS_COUNT_MAX", "NAME_MAX", "NAN", "NFDBITS", "NGROUPS_MAX", "NL_ARGMAX",
			"NL_LANGMAX", "NL_MSGMAX", "NL_NMAX", "NL_SETMAX", "NL_TEXTMAX", "NR_OPEN", "NZERO", "offsetof", "PAGE_SIZE", "PAGESIZE",
			"P_ALL", "PASS_MAX", "PATH_MAX", "PDP_ENDIAN", "PIPE_BUF", "P_PGID", "P_PID", "P_PIDFD", "PTHREAD_DESTRUCTOR_ITERATIONS",
			"PTHREAD_KEYS_MAX", "P_tmpdir", "PTRDIFF_C", "PTRDIFF_MAX", "PTRDIFF_MIN", "RAND_MAX", "RTSIG_MAX", "SCHAR_MAX", "SCHAR_MIN",
			"SEEK_CUR", "SEEK_END", "SEEK_SET", "SEM_VALUE_MAX", "setjmp", "SHRT_MAX", "SHRT_MIN", "SIGABRT", "SIG_ATOMIC_MAX",
			"SIG_ATOMIC_MIN", "SIG_DFL", "SIG_ERR", "SIGFPE", "SIG_IGN", "SIGILL", "SIGINT", "signbit", "SIGSEGV", "sigsetjmp", "SIGTERM",
			"SIZE_MAX", "SIZE_T_MAX", "SSIZE_MAX", "stderr", "stdin", "stdout", "STRUCT_MALLINFO_DECLARED", "TMP_MAX", "TTY_NAME_MAX",
			"UCHAR_MAX", "UID_MAX", "UINT16_C", "UINT16_MAX", "UINT32_C", "UINT32_MAX", "UINT64_C", "UINT64_MAX", "UINT8_C", "UINT8_MAX",
			"UINT_FAST16_C", "UINT_FAST16_MAX", "UINT_FAST32_C", "UINT_FAST32_MAX", "UINT_FAST64_C", "UINT_FAST64_MAX", "UINT_FAST8_C",
			"UINT_FAST8_MAX", "UINT_LEAST16_C", "UINT_LEAST16_MAX", "UINT_LEAST32_C", "UINT_LEAST32_MAX", "UINT_LEAST64_C",
			"UINT_LEAST64_MAX", "UINT_LEAST8_C", "UINT_LEAST8_MAX", "UINT_MAX", "UINTMAX_C", "UINTMAX_MAX", "UINTPTR_C", "UINTPTR_MAX",
			"ULLONG_MAX", "ULONG_LONG_MAX", "ULONG_MAX", "USHRT_MAX", "va_arg", "va_copy", "va_end", "va_start", "WCHAR_MAX", "WCHAR_MIN",
			"WCONTINUED", "WCOREDUMP", "WEOF", "W_EXITCODE", "WEXITED", "WEXITSTATUS", "WIFCONTINUED", "WIFEXITED", "WIFSIGNALED",
			"WIFSTOPPED", "WINT_MAX", "WINT_MIN", "WNOHANG", "WNOWAIT", "WORD_BIT", "W_STOPCODE", "WSTOPPED", "WSTOPSIG", "WTERMSIG",
			"WUNTRACED", "XATTR_LIST_MAX", "XATTR_NAME_MAX", "XATTR_SIZE_MAX",
			// Predefined by GCC and Clang in GNU mode
			"linux", "unix", "i386",
			// Macros of hl.h and hlc.h without an HL_ or hl_ prefix
			"ASAN_DISABLE", "ASAN_JIT_STACK", "C_FUNCTION_BEGIN", "C_FUNCTION_END", "DEFINE_PRIM", "DEFINE_PRIM_WITH_NAME", "EXPORT",
			"HLC_H", "IMPORT", "IS_64", "MEM_ALIGN_DOUBLE", "MEM_HAS_PTR", "MEM_KIND_DYNAMIC", "MEM_KIND_FINALIZER", "MEM_KIND_NOPTR",
			"MEM_KIND_RAW", "MEM_ZERO", "pstrchr", "pstrlen", "TYPE_STR", "USE_BUILTIN_DEBUG_TRAP", "USTR"
		];

		var pos = Context.currentPos();

		for (k in keywords) {
			fields.push({
				pos: pos,
				name: "_test_" + k,
				meta: [{pos: pos, name: ":native", params: [macro $v{k}]}],
				kind: FVar(macro :String, null)
			});

			fields.push({
				pos: pos,
				name: "_test2_" + k,
				meta: [{pos: pos, name: ":native", params: [macro $v{'__' + k}]}],
				kind: FVar(macro :String, null)
			});
		}

		return fields;
	}
}
