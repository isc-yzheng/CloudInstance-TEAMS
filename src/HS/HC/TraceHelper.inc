ROUTINE HS.HC.TraceHelper [Type=INC]
#def1Arg HSTRACE(%args) DO:(##this.TraceOperations'=""&&(##this.TraceOperations'="*ERRORSONLY*")&&(##this.TraceOperations'="*MINIMAL*")) ##this.HSTrace($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg HSTRACEMIN(%args) DO:(##this.TraceOperations'=""&&(##this.TraceOperations'="*ERRORSONLY*")) ##this.HSTrace($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg HSTRACEERROR(%args) DO:##this.TraceOperations'="" ##this.HSTrace($$$CurrentClass,$$$CurrentMethod,%args)
#define HSTRACING ##this.TraceOperations'=""
#def1Arg HSTRACEHOST(%args) DO $zobjmethod(%HSTraceHost,"HSTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#define HSTRACEHOSTSTART(%host) Set %HSTraceHost=%host
#def1Arg HSTRACECALLED(%args) DO:($D(%HSTraceHost)&&(%HSTraceHost.TraceOperations'="")&&(%HSTraceHost.TraceOperations'="*ERRORSONLY*")&&(%HSTraceHost.TraceOperations'="*MINIMAL*")) $zobjmethod(%HSTraceHost,"HSTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg HSTRACECALLEDMIN(%args) DO:($D(%HSTraceHost)&&(%HSTraceHost.TraceOperations'="")&&(%HSTraceHost.TraceOperations'="*ERRORSONLY*")) $zobjmethod(%HSTraceHost,"HSTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg HSTRACECALLEDERROR(%args) DO:($D(%HSTraceHost)&&(%HSTraceHost.TraceOperations'="")) $zobjmethod(%HSTraceHost,"HSTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#define HSTRACINGCALLED $D(%HSTraceHost)
#define HSTRACESTARTCALL Set:##this.TraceOperations'="" %HSTraceHost=##This
#define HSTRACEENDCALL Kill %HSTraceHost
