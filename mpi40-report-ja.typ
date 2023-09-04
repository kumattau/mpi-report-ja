= MPI: A Message-Passing Interface Standard Version 4.0

:doctype: book
:sectnums:
:sectnumlevels: 3
:toc: left
:toclevels: 4

== List of Figures

== List of Tables

== Acknowledgements

== Introduction to MPI

=== Overview and Goals

=== Background of MPI-1.0

=== Background of MPI-1.1, MPI-1.2, and MPI-2.0

=== Background of MPI-1.3 and MPI-2.1

=== Background of MPI-2.2

=== Background of MPI-3.0

=== Background of MPI-3.1

=== Background of MPI-4.0

=== Who Should Use This Standard?

=== What Platforms Are Targets for Implementation?

=== What Is Included in the Standard?

=== What Is Not Included in the Standard?

=== Organization of This Document

== MPI Terms and Conventions

=== Document Notation

=== Naming Conventions

=== Procedure Specification

=== Semantic Terms

==== MPI Operations

==== MPI Procedures

==== MPI Datatypes

=== Datatypes

==== Opaque Objects

MPI manages system memory that is used for buffering messages and for storing internal representations of various MPI objects such as groups, communicators, datatypes, etc.
This memory is not directly accessible to the user, and objects stored there are opaque: their size and shape is not visible to the user.
Opaque objects are accessed via handles, which exist in user space.
MPI procedures that operate on opaque objects are passed handle arguments to access these objects.
In addition to their use by MPI calls for object access, handles can participate in assignments and comparisons.

MPIは、メッセージのバッファリングや、グループ、コミュニケータ、データ型などの様々なMPIオブジェクトの内部表現を格納するために使用されるシステムメモリを管理します。 
このメモリはユーザが直接アクセスできるものではなく、そこに格納されたオブジェクトは不透明です。
不透明なオブジェクトは、ユーザ空間に存在するハンドルを介してアクセスされます。
不透明オブジェクトを操作するMPI手続きは、これらのオブジェクトにアクセスするためにハンドル引数を渡されます。
MPI呼び出しによるオブジェクトへのアクセスに加えて、ハンドルは代入や比較に参加することができます。

In Fortran with USE mpi or INCLUDE 'mpif.h', all handles have type INTEGER.
In Fortran with USE mpi_f08, and in C, a different handle type is defined for each category of objects.
With Fortran USE mpi_f08, the handles are defined as Fortran BIND(C) derived types that consist of only one element INTEGER :: MPI_VAL.
The internal handle value is identical to the Fortran INTEGER value used in the mpi module and mpif.h.
The operators ".EQ.", ".NE.", "==" and "/=" are overloaded to allow the comparison of these handles.
The type names are identical to the names in C, except that they are not case sensitive.

USE mpi または INCLUDE 'mpif.h' を使用する Fortran では、すべてのハンドルの型は INTEGER です。
USE mpi_f08 を使用する Fortran および C では、オブジェクトのカテゴリごとに異なるハンドル型が定義されます。
USE mpi_f08 を使用する Fortran では、ハンドルは1つの要素 INTEGER :: MPI_VAL です。
内部ハンドルの値は mpi モジュールと mpif.h で使用される Fortran INTEGER と同じです。
演算子 ".EQ.", ".NE.", "==", "/=" はこれらのハンドルの比較を可能にするためにオーバーロードされます。
型名は、大文字と小文字を区別しないことを除いて、C言語の型名と同じです。

[source,fortran]
----
TYPE, BIND(C) :: MPI_Comm
 INTEGER :: MPI_VAL
END TYPE MPI_Comm
----

The C types must support the use of the assignment and equality operators.

Cの型は、代入演算子と等号演算子の使用をサポートしなければなりません。

NOTE: *Advice to implementors.*
In Fortran, the handle can be an index into a table of opaque objects in a system table; in C it can be such an index or a pointer to the object.
(End of advice to implementors.)

NOTE: *実装者へのアドバイス*
Fortranでは、ハンドルはシステム・テーブル内の不透明オブジェクトのテーブルへのインデックスです。
(実装者へのアドバイスの終わり)

NOTE: *Rationale.*
Since the Fortran integer values are equivalent, applications can easily convert MPI handles between all three supported Fortran methods.
For example, an integer communicator handle COMM can be converted directly into an exactly equivalent mpi_f08 communicator handle named comm_f08 by comm_f08%MPI_VAL=COMM, and vice versa.
The use of the INTEGER defined handles and the BIND(C) derived type handles is different: Fortran 2003 (and later) define that BIND(C) derived types can be used within user defined common blocks, but it is up to the rules of the companion C compiler how many numerical storage units are used for these BIND(C) derived type handles.
Most compilers use one unit for both, the INTEGER handles and the handles defined as BIND(C) derived types.
(End of rationale.)

NOTE: *根拠*
Fortranの整数値は等価であるため、アプリケーションはサポートされている3つのFortranメソッド間でMPIハンドルを簡単に変換することができます。
例えば、整数値のコミュニケータハンドルCOMMはcomm_f08%MPI_VAL=COMMによってcomm_f08 という名前の mpi_f08 コミュニケータハンドルに直接変換することができます。
INTEGER定義ハンドルとBIND(C)派生型ハンドルの使用方法は異なります: Fortran 2003(およびそれ以降)では、BIND(C)派生型はユーザ定義の共通ブロック内で使用できると定義されていますが、これらのBIND(C)派生型ハンドルに何個の数値記憶ユニットを使用するかはコンパイラの規則次第です。
ほとんどのコンパイラは、INTEGERハンドルとBIND©派生型として定義されたハンドルの両方に1単位を使用します。
(根拠終わり)

NOTE: *Advice to users.*
If a user wants to substitute mpif.h or the mpi module by the mpi_f08 module and the application program stores a handle in a Fortran common block then it is necessary to change the Fortran support method in all application routines that use this common block, because the number of numerical storage units of such a handle can be different in the two modules.
(End of advice to users.)

NOTE: *ユーザへのアドバイス*
もし、ユーザが mpif.h または mpi モジュールを mpi_f08 モジュールで置き換えたい場合で、アプリケーションプログラムが Fortran 共通ブロックにハンドルを格納する場合、この共通ブロックを使用するすべてのアプリケーションルーチンで Fortran サポートメソッドを変更する必要があります。
(ユーザーへのアドバイスの終わり)

Opaque objects are allocated and deallocated by calls that are specific to each object type.
These are listed in the sections where the objects are described.
The calls accept a handle argument of matching type.
In an allocate call this is an OUT argument that returns a valid reference to the object.
In a call to deallocate this is an INOUT argument which returns with an "invalid handle" value.
MPI provides an "invalid handle" constant for each object type.
Comparisons to this constant are used to test for validity of the handle.

不透明オブジェクトは、各オブジェクトタイプに固有の呼び出しによって割り当てと割り当て解除が行われます。
これらの呼び出しは、オブジェクトが説明されているセクションにリストされています。
呼び出しは、型が一致する handle 引数を受け取ります。
allocate呼び出しでは、これはオブジェクトへの有効な参照を返すOUT引数です。
deallocate呼び出しでは、これは "invalid handle"値で返すINOUT引数です。
MPIは各オブジェクト型に対して "無効なハンドル"定数を提供します。
この定数との比較がハンドルの有効性をテストするために使用されます。

A call to a deallocate routine invalidates the handle and marks the object for deallocation.
The object is not accessible to the user after the call. However, MPI need not deallocate the object immediately.
Any operation pending (at the time of the deallocate) that involves this object will complete normally; the object will be deallocated afterwards.

deallocateルーチンを呼び出すと、ハンドルは無効になり、そのオブジェクトは割り当てが解除されます。
この呼び出しの後、ユーザはオブジェクトにアクセスできなくなります。しかし、MPIは直ちにオブジェクトを解放する必要はありません。
deallocateされた時点で保留されている、このオブジェクトに関係する操作はすべて正常に完了し、オブジェクトはその後にdeallocateされます。

An opaque object and its handle are significant only at the process where the object was created and cannot be transferred to another process.
MPI provides certain predefined opaque objects and predefined, static handles to these objects.
The user must not free such objects.

不透明オブジェクトとそのハンドルは、そのオブジェクトが作成されたプロセスでのみ重要であり、他のプロセスに転送することはできません。
MPIは、特定の定義済み不透明オブジェクトと、これらのオブジェクトへの定義済み静的ハンドルを提供します。
ユーザはそのようなオブジェクトを解放してはいけません。

NOTE: *Rationale.*
This design hides the internal representation used for MPI data structures, thus allowing similar calls in C and Fortran.
It also avoids conflicts with the typing rules in these languages, and easily allows future extensions of functionality.
The mechanism for opaque objects used here loosely follows the POSIX Fortran binding standard. +
The explicit separation of handles in user space and objects in system space allows space-reclaiming and deallocation calls to be made at appropriate points in the user program.
If the opaque objects were in user space, one would have to be very careful not to go out of scope before any pending operation requiring that object completed.
The specified design allows an object to be marked for deallocation, the user program can then go out of scope, and the object itself still persists until any pending operations are complete. +
The requirement that handles support assignment/comparison is made since such operations are common.
This restricts the domain of possible implementations.
The alternative in C would have been to allow handles to have been an arbitrary, opaque type.
This would force the introduction of routines to do assignment and comparison, adding complexity, and was therefore ruled out.
In Fortran, the handles are defined such that assignment and comparison are available through the operators of the language or overloaded versions of these operators. (End of rationale.)

NOTE: *根拠*
この設計は、MPIデータ構造に使用される内部表現を隠蔽するため、CやFortranでも同様の呼び出しが可能です。
また、これらの言語の型付け規則との衝突を回避し、将来的な機能拡張を容易にします。
ここで使用されている不透明オブジェクトのメカニズムは、POSIX Fortranバインディング標準に緩く従っています。 +
ユーザー空間のハンドルとシステム空間のオブジェクトを明示的に分離することで、ユーザープログラムの適切な箇所で空間奪還と解放の呼び出しを行うことができます。
不透明なオブジェクトがユーザー空間にあった場合、そのオブジェクトを必要とする保留中の操作が完了する前にスコープ外に出ないように、細心の注意を払わなければなりません。
指定された設計では、オブジェクトに割り当て解除のマークを付けることができ、ユーザー・プログラムはスコープ外に出ることができます。 +
ハンドルの割り当て/比較をサポートするという要件は、そのような操作が一般的であるためです。
これにより、実装可能な領域が制限されます。
C言語の代替案としては、ハンドルを任意の不透明な型にすることも可能だったと思います。
この場合、代入と比較を行うルーチンを導入しなければならなくなり、複雑さが増すため、除外されました。
Fortranでは、ハンドルの代入と比較は、その言語の演算子か、これらの演算子のオーバーロード版で利用できるように定義されています。(根拠終わり)

NOTE: *Advice to users.*
A user may accidentally create a dangling reference by assigning to a handle the value of another handle, and then deallocating the object associated with these handles.
Conversely, if a handle variable is deallocated before the associated object is freed, then the object becomes inaccessible (this may occur, for example, if the handle is a local variable within a subroutine, and the subroutine is exited before the associated object is deallocated).
It is the user’s responsibility to avoid adding or deleting references to opaque objects, except as a result of MPI calls that allocate or deallocate such objects. (End of advice to users.)

NOTE: *ユーザへのアドバイス*
ユーザは、ハンドルに別のハンドルの値を代入し、その後これらのハンドルに関連付けられたオブジェクトを解放することで、誤ってぶら下がり参照を作成する可能性があります。
逆に、関連するオブジェクトが解放される前にハンドル変数が解放されると、そのオブジェクトはアクセスできなくなります（例えば、ハンドルがサブルーチン内のローカル変数であり、関連するオブジェクトが解放される前にサブルーチンが終了した場合などに、このような現象が発生する可能性があります）。
不透明なオブジェクトへの参照を追加したり削除したりしないようにするのは、そのようなオブジェクトを割り当てたり解放したりするMPI呼び出しの結果以外では、ユーザの責任です。(ユーザへの忠告を終わります)。

NOTE: *Advice to implementors.*
The intended semantics of opaque objects is that opaque objects are separate from one another; each call to allocate such an object copies all the information required for the object.
Implementations may avoid excessive copying by substituting referencing for copying.
For example, a derived datatype may contain references to its components, rather than copies of its components; a call to MPI_COMM_GROUP may return a reference to the group associated with the communicator, rather than a copy of this group.
In such cases, the implementation must maintain reference counts, and allocate and deallocate objects in such a way that the visible effect is as if the objects were copied. (End of advice to implementors.)

NOTE: *実装者へのアドバイス*
不透明オブジェクトの意図されたセマンティクスは、不透明オブジェクトは互いに分離しているということです。そのようなオブジェクトを割り当てるための各呼び出しは、そのオブジェクトに必要なすべての情報をコピーします。
実装では、コピーの代わりに参照を使用することで、過剰なコピーを避けることができます。
MPI_COMM_GROUP を呼び出すと、そのグループのコピーではなく、コミュニケータに関連付けられたグループへの参照が返されます。
このような場合、実装は参照カウントを維持し、オブジェクトがコピーされたかのように見えるようにオブジェクトを割り当てたり、割り当て解除したりしなければなりません。(実装者へのアドバイスはここまで）。


==== Array Arguments

==== State

==== Named Constants

MPI procedures sometimes assign a special meaning to a special value of a basic type argument; e.g., tag is an integer-valued argument of point-to-point communication operations, with a special wild-card value, MPI_ANY_TAG.
Such arguments will have a range of regular values, which is a proper subrange of the range of values of the corresponding basic type; special values (such as MPI_ANY_TAG) will be outside the regular range.
The range of regular values, such as tag, can be queried using environmental inquiry functions, see Chapter 9.
The range of other values, such as source, depends on values given by other MPI routines (in the case of source it is the communicator size).

MPI手続きは、基本型の引数の特別な値に特別な意味を割り当てることがあります。例えば、tagはポイントツーポイント通信操作の整数値の引数で、MPI_ANY_TAGという特別なワイルドカード値を持ちます。
このような引数には、対応する基本型の値の範囲の適切な部分範囲である正規値の範囲があります。特殊な値(MPI_ANY_TAGなど)は正規の範囲外となります。
tagのような正規値の範囲は、環境問い合わせ関数を使用して問い合わせることができます。
source のような他の値の範囲は、他の MPI ルーチンで与えられた値に依存します (source の場合はコミュニケータサイズです)。

MPI also provides predefined named constant handles, such as MPI_COMM_WORLD.

MPI は MPI_COMM_WORLD のような定義済みの名前付き定数ハンドルも提供します。

All named constants, with the exceptions noted below for Fortran, can be used in initialization expressions or assignments, but not necessarily in array declarations or as labels in C switch or Fortran select/case statements.
This implies named constants to be link-time but not necessarily compile-time constants.
The named constants listed below are required to be compile-time constants in both C and Fortran.
These constants do not change values during execution.
Opaque objects accessed by constant handles are defined and do not change value between MPI initialization (MPI_INIT) and MPI completion (MPI_FINALIZE).
The handles themselves are constants and can be also used in initialization expressions or assignments.

すべての名前付き定数は、Fortranの例外を除いて、初期化式や代入で使用することができますが、配列宣言やCのswitch文やFortranのselect/case文のラベルとして使用することはできません。
これは、名前付き定数がリンク時定数であることを意味しますが、コンパイル時定数であるとは限りません。
以下に挙げる名前付き定数は、CでもFortranでもコンパイル時定数であることが要求されます。
これらの定数は実行中に値が変わることはありません。
定数ハンドルによってアクセスされる不透明オブジェクトは、MPI の初期化 (MPI_INIT) から MPI の完了 (MPI_FINALIZE) までの間、値が変化しないように定義されています。
ハンドル自体は定数であり、初期化式や代入で使用することもできます。

The constants that are required to be compile-time constants (and can thus be used for array length declarations and labels in C switch and Fortran case/select statements) are:

コンパイル時定数として要求される定数(配列の長さの宣言やCのswitchやFortranのcase/select文のラベルに使用できる)は以下の通りです:

[source]
----
MPI_MAX_PROCESSOR_NAME
MPI_MAX_LIBRARY_VERSION_STRING
MPI_MAX_ERROR_STRING
MPI_MAX_DATAREP_STRING
MPI_MAX_INFO_KEY
MPI_MAX_INFO_VAL
MPI_MAX_OBJECT_NAME
MPI_MAX_PORT_NAME
MPI_VERSION
MPI_SUBVERSION
MPI_F_STATUS_SIZE (C only)
MPI_STATUS_SIZE (Fortran only)
MPI_ADDRESS_KIND (Fortran only)
MPI_COUNT_KIND (Fortran only)
MPI_INTEGER_KIND (Fortran only)
MPI_OFFSET_KIND (Fortran only)
MPI_SUBARRAYS_SUPPORTED (Fortran only)
MPI_ASYNC_PROTECTS_NONBLOCKING (Fortran only)
----

The constants that cannot be used in initialization expressions or assignments in Fortran are as follows:

Fortranの初期化式や代入で使用できない定数は以下の通りです:

[source]
----
MPI_BOTTOM
MPI_STATUS_IGNORE
MPI_STATUSES_IGNORE
MPI_ERRCODES_IGNORE
MPI_IN_PLACE
MPI_ARGV_NULL
MPI_ARGVS_NULL
MPI_UNWEIGHTED
MPI_WEIGHTS_EMPTY
----

NOTE: *Advice to implementors.*
In Fortran the implementation of these special constants may require the use of language constructs that are outside the Fortran standard.
Using special values for the constants (e.g., by defining them through PARAMETER statements) is not possible because an implementation cannot distinguish these values from valid data.
Typically, these constants are implemented as predefined static variables (e.g., a variable in an MPI-declared COMMON block), relying on the fact that the target compiler passes data by address. 
Inside the subroutine, this address can be extracted by some mechanism outside the Fortran standard (e.g., by Fortran extensions or by implementing the function in C).
(End of advice to implementors.)

NOTE: *実装者へのアドバイス*
Fortranでは、これらの特殊な定数の実装は、Fortran標準外の言語構造を使用する必要があるかもしれません。
実装がこれらの値を有効なデータと区別することができないため、定数に特別な値を使用する（例えば、PARAMETER文で定義する）ことはできません。
通常、これらの定数は、ターゲットコンパイラがアドレスによってデータを渡すという事実に依存して、定義済みの静的変数（例えば、MPI宣言されたCOMMONブロック内の変数）として実装されます。
サブルーチン内部では、このアドレスはFortran標準外の何らかのメカニズム（例えば、Fortranの拡張やCでの関数の実装）によって抽出することができます。
(実装者へのアドバイスの終わり)


==== Choice

==== Absolute Addresses and Relative Address Displacements

==== File Offsets

==== Counts

=== Language Binding

==== Deprecated and Removed Interfaces

==== Fortran Binding Issues

==== C Binding Issues

==== Functions and Macros

=== Processes

=== Error Handling

MPI provides the user with reliable message transmission. A message sent is always received correctly, and the user does not need to check for transmission errors, time-outs, or other error conditions.
In other words, MPI does not provide mechanisms for dealing with transmission failures in the communication system.
If the MPI implementation is built on an unreliable underlying mechanism, then it is the job of the implementor of the MPI subsystem to insulate the user from this unreliability, and to reflect only unrecoverable transmission failures.
Whenever possible, such failures will be reflected as errors in the relevant communication call.

MPIは信頼性の高いメッセージ伝送をユーザーに提供します。
送信されたメッセージは常に正しく受信され、ユーザは送信エラーやタイムアウトなどのエラー状態をチェックする必要がありません。
言い換えれば、MPIは通信システムにおける伝送障害に対処する機構を提供しません。
もしMPIの実装が信頼性の低い機構の上に構築されているのであれば、MPIサブシステムの実装者は、この信頼性の低さからユーザを隔離し、回復不可能な伝送障害だけを反映させるのが仕事です。
可能な限り、そのような失敗は関連する通信呼び出しのエラーとして反映されます。

Similarly, MPI itself provides no mechanisms for handling MPI process failures, that is, when an MPI process unexpectedly and permanently stops communicating (e.g., a software or hardware crash results in an MPI process terminating unexpectedly).

同様に、MPI自身はMPIプロセスの障害、つまりMPIプロセスが予期せず永続的に通信を停止した場合（例えば、ソフトウェアやハードウェアのクラッシュによりMPIプロセスが予期せず終了した場合）を処理するメカニズムを提供していません。

Of course, MPI programs may still be erroneous.
A program error can occur when an MPI call is made with an incorrect argument (non-existing destination in a send operation, buffer too small in a receive operation, etc.).
This type of error would occur in any implementation.
In addition, a resource error may occur when a program exceeds the amount of available system resources (number of pending messages, system buffers, etc.).

もちろん、MPIプログラムにもエラーはあります。
プログラムのエラーは、MPIコールに不正な引数（送信操作で宛先が存在しない、受信操作でバッファが小さすぎる、など）が指定された場合に発生します。
この種のエラーはどのような実装でも発生します。
さらに、リソースエラーは、プログラムが利用可能なシステムリソースの量（保留中のメッセージの数、システムバッファなど）を超えた場合に発生する可能性があります。

The occurrence of this type of error depends on the amount of available resources in the system and the resource allocation mechanism used; this may differ from system to system.
A high-quality implementation will provide generous limits on the important resources so as to alleviate the portability problem this represents.

この種のエラーの発生は、システムで利用可能なリソースの量と、使用されるリソース割り当てメカニズムに依存します。
高品質な実装では、重要なリソースに寛大な制限を設け、これが示す移植性の問題を緩和します。

In C and Fortran, almost all MPI calls return a code that indicates successful completion of the operation.
Whenever possible, MPI calls return an error code if an error occurred during the call.
By default, an error detected during the execution of the MPI library causes the parallel computation to abort, except for file operations.
However, MPI provides mechanisms for users to change this default and to handle recoverable errors. 
The user may specify that no error is fatal, and handle error codes returned by MPI calls by themselves.
Also, the user may provide user-defined error-handling routines, which will be invoked whenever an MPI call returns abnormally.
The MPI error handling facilities are described in Section 9.3.

CおよびFortranでは、ほとんどすべてのMPIコールは操作の正常終了を示すコードを返します。
MPIコールは可能な限り、コール中にエラーが発生した場合にエラーコードを返します。
デフォルトでは、MPIライブラリの実行中に検出されたエラーは、ファイル操作を除いて並列計算を中断させます。
しかし、MPIはユーザがこのデフォルトを変更し、回復可能なエラーを処理するための機構を提供します。
ユーザは、致命的なエラーでないことを指定し、MPIコールから返されるエラーコードを自分で処理することができます。
また、ユーザ定義エラー処理ルーチンを用意し、MPIコールが異常終了したときに呼び出すこともできます。
MPIエラー処理機能については9.3節で説明します。

Several factors limit the ability of MPI calls to return with meaningful error codes when an error occurs.
MPI may not be able to detect some errors; other errors may be too expensive to detect in normal execution mode; some faults (e.g., memory faults) may corrupt the state of the MPI library and its outputs; finally some errors may be "catastrophic" and may prevent MPI from returning control to the caller.
On the other hand, some errors may be detected after the associated operation has completed; some errors may not have a communicator, window, or file on which an error may be raised.
In such cases, these errors will be raised on the communicator MPI_COMM_SELF when using the World Model (see Section 11.2).
When MPI_COMM_SELF is not initialized (i.e., before MPI_INIT / MPI_INIT_THREAD, after MPI_FINALIZE, or when using the Sessions Model exclusively) the error raises the initial error handler (set during the launch operation, see 11.8.4).
The Sessions Model is described in Section 11.3.

MPIコールがエラー発生時に意味のあるエラーコードを返すことを制限するいくつかの要因があります。
あるエラー(例えば、メモリエラー)はMPIライブラリとその出力の状態を壊してしまう可能性があります。
一方、エラーの中には、関連する操作が完了した後に検出されるものもあります。
また、エラーが発生するようなコミュニケータ、ウィンドウ、ファイルが存在しないものもあります。
そのような場合、ワールドモデル(セクション11.2を参照)を使用する場合、これらのエラーはコミュニケータMPI_COMM_SELF上で発生します。
MPI_COMM_SELF が初期化されていない場合 (MPI_INIT / MPI_INIT_THREAD の前、MPI_FINALIZE の後、またはセッションズモデルのみを使用している場合)、エラーは初期エラーハンドラ (起動操作中に設定されます。11.8.4 参照) を発生させます。
セッションズ・モデルについてはセクション11.3で説明します。

An example of such a case arises because of the nature of asynchronous communications: MPI calls may initiate operations that continue asynchronously after the call returned.
Thus, the operation may return with a code indicating successful completion, yet later cause an error to be raised.
If there is a subsequent call that relates to the same operation (e.g., a call that verifies that an asynchronous operation has completed) then the error argument associated with this call will be used to indicate the nature of the error.
In a few cases, the error may occur after all calls that relate to the operation have completed, so that no error value can be used to indicate the nature of the error (e.g., an error on the receiver in a send with the ready mode).

非同期通信の性質上、このようなケースが発生する: MPI呼び出しは、呼び出しが返った後も非同期で継続する操作を開始することがあります。
MPIコールは、コールが返った後も非同期に継続するオペレーションを開始することがあります。
したがって、オペレーションが正常に完了したことを示すコードで返ったにもかかわらず、後でエラーが発生することがあります。
同じ操作に関連する後続の呼び出し(例えば、非同期操作が完了したことを確認する呼び出し)がある場合、この呼び出しに関連するエラー引数は、エラーの性質を示すために使用されます。
場合によっては、操作に関連するすべての呼が完了した後にエラーが発生し、 エラー値を使用してエラーの性質を示すことができないことがある(たとえば、 レディモードでの送信における受信側のエラー)。

This document does not specify the state of a computation after an erroneous MPI call has occurred.
The desired behavior is that a relevant error code be returned, and the effect of the error be localized to the greatest possible extent.
E.g., it is highly desirable that an erroneous receive call will not cause any part of the receiver's memory to be overwritten, beyond the area specified for receiving the message.

この文書では、誤ったMPIコールが発生した後の計算の状態については規定しません。
望ましい動作は、関連するエラーコードが返され、エラーの影響が可能な限り局所化されることです。
例えば、誤った受信呼び出しが発生しても、メッセージを受信するために指定された領域を超えて、受信側のメモリの一部が上書きされないことが非常に望ましいです。

Implementations may go beyond this document in supporting in a meaningful manner MPI calls that are defined here to be erroneous.
For example, MPI specifies strict type matching rules between matching send and receive operations: it is erroneous to send a floating point variable and receive an integer.
Implementations may go beyond these type matching rules, and provide automatic type conversion in such situations.
It will be helpful to generate warnings for such nonconforming behavior.

実装は、ここで誤りと定義されているMPIコールを意味のある形でサポートするために、このドキュメントを越えてもよい。
例えば、MPIは送信操作と受信操作のマッチングに厳格な型マッチングルールを規定しています: 浮動小数点変数を送信して整数を受信することは誤りです。
実装は、これらの型照合ルールを超えて、そのような状況で自動的な型変換を提供するかもしれません。
そのような不適合な動作に対する警告を生成することは有益だと思います。

MPI defines a way for users to create new error codes as defined in Section 9.5.

MPIは、セクション9.5で定義されているように、ユーザが新しいエラーコードを作成する方法を定義しています。


=== Implementation Issues

==== Independence of Basic Runtime Routines

==== Interaction with Signals

=== Examples

== Point-to-Point Communication

=== Introduction

=== Blocking Send and Receive Operations

==== Blocking Send

==== Message Data

==== Message Envelope

==== Blocking Receive

==== Return Status

==== Passing MPI_STATUS_IGNORE for Status

==== Blocking Send-Receive

=== Datatype Matching and Data Conversion

==== Type Matching Rules

===== Type MPI_CHARACTER

==== Data Conversion

=== Communication Modes

=== Semantics of Point-to-Point Communication

=== Buffer Allocation and Usage

==== Model Implementation of Buffered Mode

=== Nonblocking Communication

==== Communication Request Objects

==== Communication Initiation

==== Communication Completion

==== Semantics of Nonblocking Communications

==== Multiple Completions

==== Non-Destructive Test of status

==== Probe and Cancel

==== Probe

==== Matching Probe

==== Matched Receives

==== Cancel

=== Persistent Communication Requests

=== Null Processes

== Partitioned Point-to-Point Communication

=== Introduction

=== Semantics of Partitioned Point-to-Point Communication

==== Communication Initialization and Starting with Partitioning

==== Communication Completion under Partitioning

==== Semantics of Communications in Partitioned Mode

=== Partitioned Communication Examples

==== Partition Communication with Threads/Tasks Using OpenMP 4.0 or later

==== Send-only Partitioning Example with Tasks and OpenMP version 4.0 or later

==== Send and Receive Partitioning Example with OpenMP version 4.0 or later

== Datatypes

=== Derived Datatypes

==== Type Constructors with Explicit Addresses

==== Datatype Constructors

==== Subarray Datatype Constructor

==== Distributed Array Datatype Constructor

==== Address and Size Functions

==== Lower-Bound and Upper-Bound Markers

==== Extent and Bounds of Datatypes

==== True Extent of Datatypes

==== Commit and Free

==== Duplicating a Datatype

==== Use of General Datatypes in Communication

==== Correct Use of Addresses

==== Decoding a Datatype

==== Examples

=== Pack and Unpack

=== Canonical MPI_PACK and MPI_UNPACK

== Collective Communication

=== Introduction and Overview

=== Communicator Argument

==== Specifics for Intra-Communicator Collective Operations

==== Applying Collective Operations to Inter-Communicators

==== Specifics for Inter-Communicator Collective Operations

=== Barrier Synchronization

=== Broadcast

==== Example using MPI_BCAST

=== Gather

==== Examples using MPI_GATHER, MPI_GATHERV

=== Scatter

==== Examples using MPI_SCATTER, MPI_SCATTERV

=== Gather-to-all

==== Example using MPI_ALLGATHER

=== All-to-All Scatter/Gather

=== Global Reduction Operations

==== Reduce

==== Predefined Reduction Operations

==== Signed Characters and Reductions

==== MINLOC and MAXLOC

==== User-Defined Reduction Operations

===== Example of User-Defined Reduce

==== All-Reduce

==== Process-Local Reduction

=== Reduce-Scatter

==== MPI_REDUCE_SCATTER_BLOCK

==== MPI_REDUCE_SCATTER

=== Scan

==== Inclusive Scan

==== Exclusive Scan

==== Example using MPI_SCAN

=== Nonblocking Collective Operations

==== Nonblocking Barrier Synchronization

==== Nonblocking Broadcast

===== Example using MPI_IBCAST

==== Nonblocking Gather

==== Nonblocking Scatter

==== Nonblocking Gather-to-all

==== Nonblocking All-to-All Scatter/Gather

==== Nonblocking Reduce

==== Nonblocking All-Reduce

==== Nonblocking Reduce-Scatter with Equal Blocks

==== Nonblocking Reduce-Scatter

==== Nonblocking Inclusive Scan

==== Nonblocking Exclusive Scan

=== Persistent Collective Operations

==== Persistent Barrier Synchronization

==== Persistent Broadcast

==== Persistent Gather

==== Persistent Scatter

==== Persistent Gather-to-all

==== Persistent All-to-All Scatter/Gather

==== Persistent Reduce

==== Persistent All-Reduce

==== Persistent Reduce-Scatter with Equal Blocks

==== Persistent Reduce-Scatter

==== Persistent Inclusive Scan

==== Persistent Exclusive Scan

=== Correctness

== Groups, Contexts, Communicators, and Caching

=== Introduction

==== Features Needed to Support Libraries

==== MPI’s Support for Libraries

=== Basic Concepts

==== Groups

==== Contexts

==== Intra-Communicators

==== Predefined Intra-Communicators

=== Group Management

==== Group Accessors

==== Group Constructors

==== Group Destructors

=== Communicator Management

==== Communicator Accessors

==== Communicator Constructors

==== Communicator Destructors

==== Communicator Info

=== Motivating Examples

==== Current Practice #1

==== Current Practice #2

==== (Approximate) Current Practice #3

==== Communication Safety Example

==== Library Example #1

==== Library Example #2

=== Inter-Communication

==== Inter-Communicator Accessors

==== Inter-Communicator Operations

==== Inter-Communication Examples

===== Example 1: Three-Group "Pipeline"

===== Example 2: Three-Group "Ring"

=== Caching

==== Functionality

==== Communicators

==== Windows

==== Datatypes

==== Error Class for Invalid Keyval

==== Attributes Example

=== Naming Objects

=== Formalizing the Loosely Synchronous Model

==== Basic Statements

==== Models of Execution

===== Static Communicator Allocation

===== Dynamic Communicator Allocation

===== The General Case

== Process Topologies

=== Introduction

=== Virtual Topologies

=== Embedding in MPI

=== Overview of the Functions

=== Topology Constructors

==== Cartesian Constructor

==== Cartesian Convenience Function: MPI_DIMS_CREATE

==== Graph Constructor

==== Distributed Graph Constructor

==== Topology Inquiry Functions

==== Cartesian Shift Coordinates

==== Partitioning of Cartesian Structures

==== Low-Level Topology Functions

=== Neighborhood Collective Communication

==== Neighborhood Gather

==== Neighbor Alltoall

=== Nonblocking Neighborhood Communication

==== Nonblocking Neighborhood Gather

==== Nonblocking Neighborhood Alltoall

=== Persistent Neighborhood Communication

==== Persistent Neighborhood Gather

==== Persistent Neighborhood Alltoall

=== An Application Example

== MPI Environmental Management

=== Implementation Information

==== Version Inquiries

==== Environmental Inquiries

===== Tag Values

===== Host Rank

===== IO Rank

===== Clock Synchronization

===== Inquire Processor Name

=== Memory Allocation

=== Error Handling

==== Error Handlers for Communicators

==== Error Handlers for Windows

==== Error Handlers for Files

==== Error Handlers for Sessions

==== Freeing Errorhandlers and Retrieving Error Strings

=== Error Codes and Classes

=== Error Classes, Error Codes, and Error Handlers

=== Timers and Synchronization

== The Info Object

== Process Initialization, Creation, and Management

=== Introduction

=== The World Model

==== Starting MPI Processes

==== Finalizing MPI

==== Determining Whether MPI Has Been Initialized When Using the World Model

==== Allowing User Functions at MPI Finalization

=== The Sessions Model

==== Session Creation and Destruction Methods

==== Processes Sets

==== Runtime Query Functions

==== Sessions Model Examples

=== Common Elements of Both Process Models

==== MPI Functionality that is Always Available

==== Aborting MPI Processes

=== Portable MPI Process Startup

=== MPI and Threads

==== General

==== Clarifications

=== The Dynamic Process Model

==== Starting Processes

==== The Runtime Environment

=== Process Manager Interface

==== Processes in MPI

==== Starting Processes and Establishing Communication

==== Starting Multiple Executables and Establishing Communication .

==== Reserved Keys

==== Spawn Example

=== Establishing Communication

==== Names, Addresses, Ports, and All That

==== Server Routines

==== Client Routines

==== Name Publishing

==== Reserved Key Values

==== Client/Server Examples

=== Other Functionality

==== Universe Size

==== Singleton MPI Initialization

==== MPI_APPNUM

==== Releasing Connections

==== Another Way to Establish MPI Communication

== One-Sided Communications

=== Introduction

=== Initialization

==== Window Creation

==== Window That Allocates Memory

==== Window That Allocates Shared Memory

==== Window of Dynamically Attached Memory

==== Window Destruction

==== Window Attributes

==== Window Info

=== Communication Calls

==== Put

==== Get

==== Examples for Communication Calls

==== Accumulate Functions

===== Accumulate Function

===== Get Accumulate Function

===== Fetch and Op Function

===== Compare and Swap Function

==== Request-based RMA Communication Operations

=== Memory Model

=== Synchronization Calls

==== Fence

==== General Active Target Synchronization

==== Lock

==== Flush and Sync

==== Assertions

==== Miscellaneous Clarifications

=== Error Handling

==== Error Handlers

==== Error Classes

=== Semantics and Correctness

==== Atomicity

==== Ordering

==== Progress

==== Registers and Compiler Optimizations

=== Examples

== External Interfaces

=== Introduction

=== Generalized Requests

==== Examples

=== Associating Information with Status

== I/O

=== Introduction

==== Definitions

=== File Manipulation

==== Opening a File

==== Closing a File

==== Deleting a File

==== Resizing a File

==== Preallocating Space for a File

==== Querying the Size of a File

==== Querying File Parameters

==== File Info

===== Reserved File Hints

=== File Views

=== Data Access

==== Data Access Routines

===== Positioning

===== Synchronism

===== Coordination

===== Data Access Conventions

==== Data Access with Explicit Offsets

==== Data Access with Individual File Pointers

==== Data Access with Shared File Pointers

===== Noncollective Operations

===== Collective Operations

===== Seek

==== Split Collective Data Access Routines

=== File Interoperability

==== Datatypes for File Interoperability

==== External Data Representation: "external32"

==== User-Defined Data Representations

===== Extent Callback

===== Datarep Conversion Functions

==== Matching Data Representations

=== Consistency and Semantics

==== File Consistency

==== Random Access vs. Sequential Files

==== Progress

==== Collective File Operations

==== Nonblocking Collective File Operations

==== Type Matching

==== Miscellaneous Clarifications

==== MPI_Offset Type

==== Logical vs. Physical File Layout

==== File Size

==== Examples

===== Asynchronous I/O

=== I/O Error Handling

=== I/O Error Classes

=== Examples

==== Double Buffering with Split Collective I/O

==== Subarray Filetype Constructor

== Tool Support

=== Introduction

=== Profiling Interface

==== Requirements

==== Discussion

==== Logic of the Design

==== Miscellaneous Control of Profiling

==== MPI Library Implementation

==== Complications

==== Multiple Levels of Interception

=== The MPI Tool Information Interface

==== Verbosity Levels

==== Binding MPI Tool Information Interface Variables to MPI Objects

==== Convention for Returning Strings

==== Initialization and Finalization

==== Datatype System

==== Control Variables

==== Performance Variables

===== Performance Variable Classes

===== Performance Variable Query Functions

===== Performance Experiment Sessions

===== Handle Allocation and Deallocation

===== Starting and Stopping of Performance Variables

===== Performance Variable Access Functions

==== Events

===== Event Sources

===== Callback Safety Requirements

===== Event Type Query Functions

===== Handle Allocation and Deallocation

===== Handling Dropped Events

===== Reading Event Data

===== Reading Event Meta Data

==== Variable Categorization

===== Category Query Functions

===== Category Member Query Functions

==== Return Codes for the MPI Tool Information Interface

==== Profiling Interface

== Deprecated Interfaces

=== Deprecated since MPI-2.0

=== Deprecated since MPI-2.2
=== Deprecated since MPI-4.0

== Removed Interfaces

=== Removed MPI-1 Bindings

==== Overview

==== Removed MPI-1 Functions

==== Removed MPI-1 Datatypes

==== Removed MPI-1 Constants

==== Removed MPI-1 Callback Prototypes

=== C++ Bindings

== Semantic Changes and Warnings
=== Semantic Changes

==== Semantic Changes Starting in MPI-4.0

=== Additional Warnings

==== Warnings Starting in MPI-4.0

== Language Bindings

=== Support for Fortran

==== Overview

==== Fortran Support Through the mpi_f08 Module

==== Fortran Support Through the mpi Module

==== Fortran Support Through the mpif.h Include File

==== Interface Specifications, Procedure Names, and the Profiling Interface798

==== MPI for Different Fortran Standard Versions

==== Requirements on Fortran Compilers

==== Additional Support for Fortran Register-Memory-Synchronization 808

==== Additional Support for Fortran Numeric Intrinsic Types

===== Parameterized Datatypes with Specified Precision and Exponent

===== Range

===== Support for Size-specific MPI Datatypes

===== Communication With Size-specific Types

==== Problems With Fortran Bindings for MPI

==== Problems Due to Strong Typing

==== Problems Due to Data Copying and Sequence Association with Subscript Triplets

==== Problems Due to Data Copying and Sequence Association with Vector Subscripts

==== Special Constants

==== Fortran Derived Types

==== Optimization Problems, an Overview

==== Problems with Code Movement and Register Optimization

===== Nonblocking Operations

===== Persistent Operations

===== One-sided Communication

===== MPI_BOTTOM and Combining Independent Variables in Datatypes 827

===== Solutions

===== The Fortran ASYNCHRONOUS Attribute

===== Calling MPI_F_SYNC_REG

===== A User Defined Routine Instead of MPI_F_SYNC_REG

===== Module Variables and COMMON Blocks

===== The (Poorly Performing) Fortran VOLATILE Attribute

===== The Fortran TARGET Attribute

==== Temporary Data Movement and Temporary Memory Modification 832

==== Permanent Data Movement

==== Comparison with C

=== Support for Large Count and Large Byte Displacement

=== Language Interoperability

==== Introduction

==== Assumptions

==== Initialization

==== Transfer of Handles

==== Status

==== MPI Opaque Objects

===== Datatypes

===== Callback Functions

===== Error Handlers

===== Reduce Operations

==== Attributes

==== Extra-State

==== Constants

==== Interlanguage Communication

== Language Bindings Summary

=== Defined Values and Handles

==== Defined Constants

==== Types

==== Prototype Definitions

===== C Bindings

===== Fortran 2008 Bindings with the mpi_f08 Module

===== Fortran Bindings with mpif.h or the mpi Module

==== Deprecated Prototype Definitions

==== String Values

===== Default Communicator Names

===== Reserved Data Representations

===== Process Set Names

===== Info Keys

===== Info Values

=== Summary of the Semantics of all Op.-Related Routines

=== C Bindings

==== Point-to-Point Communication C Bindings

==== Partitioned Communication C Bindings

==== Datatypes C Bindings

==== Collective Communication C Bindings

==== Groups, Contexts, Communicators, and Caching C Bindings

==== Process Topologies C Bindings

==== MPI Environmental Management C Bindings

==== The Info Object C Bindings

==== Process Creation and Management C Bindings

==== One-Sided Communications C Bindings

==== External Interfaces C Bindings

==== I/O C Bindings

==== Language Bindings C Bindings

==== Tools / Profiling Interface C Bindings

==== Tools / MPI Tool Information Interface C Bindings

==== Deprecated C Bindings

=== Fortran 2008 Bindings with the mpi_f08 Module

==== Point-to-Point Communication Fortran 2008 Bindings

==== Partitioned Communication Fortran 2008 Bindings

==== Datatypes Fortran 2008 Bindings

==== Collective Communication Fortran 2008 Bindings

==== Groups, Contexts, Communicators, and Caching Fortran 2008 Bindings

==== Process Topologies Fortran 2008 Bindings

==== MPI Environmental Management Fortran 2008 Bindings

==== The Info Object Fortran 2008 Bindings

==== Process Creation and Management Fortran 2008 Bindings

==== One-Sided Communications Fortran 2008 Bindings

==== External Interfaces Fortran 2008 Bindings

==== I/O Fortran 2008 Bindings

==== Language Bindings Fortran 2008 Bindings

==== Tools / Profiling Interface Fortran 2008 Bindings

==== Deprecated Fortran 2008 Bindings

=== Fortran Bindings with mpif.h or the mpi Module

==== Point-to-Point Communication Fortran Bindings

==== Partitioned Communication Fortran Bindings

==== Datatypes Fortran Bindings

==== Collective Communication Fortran Bindings

==== Groups, Contexts, Communicators, and Caching Fortran Bindings 1020

==== Process Topologies Fortran Bindings

==== MPI Environmental Management Fortran Bindings

==== The Info Object Fortran Bindings

==== Process Creation and Management Fortran Bindings

==== One-Sided Communications Fortran Bindings

==== External Interfaces Fortran Bindings

==== I/O Fortran Bindings

==== Language Bindings Fortran Bindings

==== Tools / Profiling Interface Fortran Bindings

==== Deprecated Fortran Bindings

== Change-Log

=== Changes from Version 3.1 to Version 4.0

==== Fixes to Errata in Previous Versions of MPI

==== Changes in MPI-4.0

=== Changes from Version 3.0 to Version 3.1

==== Fixes to Errata in Previous Versions of MPI

==== Changes in MPI-3.1

=== Changes from Version 2.2 to Version 3.0

==== Fixes to Errata in Previous Versions of MPI

==== Changes in MPI-3.0

=== Changes from Version 2.1 to Version 2.2

=== Changes from Version 2.0 to Version 2.1

== Chapter Bibliography

== Index

== Index

== Constant and Predefined Handle Index

== Declarations Index

== Callback Function Prototype Index

== Function Index

