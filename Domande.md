# Possibili domande

### 1. Cos'è e come si calcola la peak performance?
Il numero di operazioni aritmetiche in virgola mobile che possono essere completate in un periodo di tempo, di solito il tempo di ciclo della macchina. Unità di misura: FLOPS.

### 2. Cos'è e come si calcola la sustained performance?
Il rapporto tra il numero di operazioni aritmetiche in virgola mobile completate e il tempo impiegato per completarle di un determinato programma. Unità di misura: FLOPS.

### 3. Com'è fatto un HPC cluster?
Un HPC cluster è composto da un insieme di nodi, ognuno dei quali è un computer indipendente. I nodi sono collegati tra loro tramite un'infrastruttura di rete ad alta velocità e bassa latenza.
Ogni nodo può essere composto da più processori, ognuno dei quali con più core, ed eventualmente più thread per core.

### 4. Definizione di Strong Scaling e Weak Scaling.
Per **strong scaling** si intende la capacità di un programma di diminuire il tempo di esecuzione all'aumentare del numero di processori, per una dimensione del problema fissata.

Per **weak scaling** si intende la capacità di un programma di mantenere costante il tempo di esecuzione all'aumentare del numero di processori, aumentando proporzionalmente la dimensione del problema.

### 5. Legge di Amdahl
La legge di Amdahl afferma che lo speedup di un programma è limitato dalla frazione sequenziale del programma stesso. In particolare, se una frazione f del programma è sequenziale, lo speedup massimo ottenibile è 1/f.
$$
S(N) = \frac{1}{f + \frac{1-f}{N}}
$$

### 6. Legge di Gustafson
La legge di Gustafson afferma che la proporzione di computazione seriale di un problema decresce all'aumentare della dimensione del problema. In particolare, se una frazione f del programma è sequenziale, all'aumentare della dimensione del problema la frazione sequenziale diventa trascurabile.
$$
S(N) = N - (N-1)f
$$

### 7. Quali sono i livelli di parallelismo?
- **Instruction Level Parallelism (ILP)**: parallelismo a livello di istruzione. Le tecniche principali sono:
  - Prefetching: durante il ciclo fetch-decode-execute, si caricano in anticipo le istruzioni in memoria mentre si eseguono le istruzioni precedenti.
  - Pipelining: generalizzazione del prefetching, in cui si eseguono contemporaneamente più istruzioni.
  - Superscalar: esecuzione di più istruzioni contemporaneamente.

- **Processor Level Parallelism**: parallelismo a livello di processore. Le tecniche principali sono:
  - Multicore: più core su un singolo processore.
  - Multiprocessor: più processori su una singola scheda madre.
  - Cluster: più nodi collegati tra loro tramite rete ad alta velocità.

- **Data Level Parallelism**: parallelismo a livello di dati. Le tecniche principali sono:
  - SIMD: Single Instruction, Multiple Data. Un'unica istruzione opera su più dati.
  - MIMD: Multiple Instruction, Multiple Data. Più istruzioni operano su più dati.


### 8. Cos'è la tassonomia di Flynn?
La topologia di Flynn classifica i computer in base al numero di flussi di istruzioni e di dati che possono essere gestiti contemporaneamente. Si distinguono quattro categorie:
- **SISD**: Single Instruction, Single Data. Un'unica istruzione opera su un unico dato. Modello sequenziale di Von Neumann.
- **SIMD**: Single Instruction, Multiple Data. Un'unica istruzione opera su più dati. Esempio: GPU, ma anche i moderni processori.
- **MISD**: Multiple Instruction, Single Data. Più istruzioni operano su un unico dato. 
- **MIMD**: Multiple Instruction, Multiple Data. Più istruzioni operano su più dati. Esempio: cluster di computer.

### 9. Cos'è la memoria condivisa e la memoria distribuita?
- **Memoria condivisa**: tutti i processori condividono un unico spazio di indirizzamento. I processori comunicano tra loro tramite variabili condivise.
- **Memoria distribuita**: ogni processore ha il proprio spazio di indirizzamento. I processori comunicano tra loro tramite un'interfaccia di di comunicazione. Esempio: cluster di computer con MPI.

### 10. Cos'è un'operazione collettiva nel contesto di MPI?
Un'operazione collettiva è un'operazione che coinvolge tutti i processi di un gruppo. Esempi di operazioni collettive:
- **Broadcast**: un processo invia un messaggio a tutti gli altri processi.
- **Scatter**: un processo invia una porzione di un array a tutti gli altri processi.
- **Gather**: un processo riceve una porzione di un array da tutti gli altri processi.
- **Reduce**: un processo riceve una porzione di un array da tutti gli altri processi e calcola una funzione di aggregazione.
- **Barrier**: tutti i processi si sincronizzano.
- **AllToAll**: ogni processo esegue uno scatter e un gather con tutti gli altri processi.
- **Scan**: ogni processo calcola una funzione di aggregazione parziale con tutti gli altri processi.
- **AllReduce**: combina una reduce e uno scatter.

### 11. Cosa sono le operazioni bloccanti e non bloccanti?
Le operazioni bloccanti sono operazioni che bloccano il processo chiamante fino al completamento dell'operazione. Le operazioni non bloccanti ritornano immediatamente al processo chiamante, che può continuare a eseguire altre operazioni.

### 12. Cos'è un synchronous send?
Un synchronous send è un'operazione di invio che blocca il processo chiamante fino a quando il messaggio non è stato ricevuto dal processo destinatario. L'overhead di sistema è minimo, ma l'overhead di sincronizzazione è massimo.

### 13. Cos'è un buffered send?
Un buffered send è un'operazione di invio che ritorna immediatamente al processo chiamante, ma il messaggio viene memorizzato in un buffer fino a quando il processo destinatario non è pronto a riceverlo. L'overhead di comunicazione è mitigato a fronte di un system overhead che origina
dal copiare il messaggio nel buffer.

### 14. Cos'è un ready send?
Un ready send è un'operazione di invio che ritorna immediatamente al processo chiamante assumendo che il processo destinatario sia pronto a ricevere il messaggio.

### 15. Cos'è un deadlock?
Un deadlock è una situazione in cui due o più processi sono in attesa indefinita di risorse che sono in possesso di un altro processo. Un deadlock può verificarsi in un sistema distribuito quando i processi non sono sincronizzati correttamente.

### 16. Cosa si intende per bisection bandwidth?
La bisection bandwidth è la larghezza di banda minima tra due metà di un sistema di rete. La bisection bandwidth è un parametro importante per la scalabilità di un sistema distribuito.

### 17. Quali sono le network topologies più comuni in un cluster HPC?
Le network topologies più comuni in un cluster HPC sono:
- **Bus**: tutti i nodi sono collegati da un unico bus.
- **Ring**: ogni nodo è collegato a due nodi adiacenti.
- **Crossbar**: ogni nodo è collegato a tutti gli altri nodi.
- **Mesh**: ogni nodo è collegato a un sottoinsieme di nodi adiacenti.

### 18. Cos'è un fat tree?
Un fat tree è una topologia di rete ad albero in cui i nodi intermedi sono costituiti da più switch. Un fat tree è una topologia di rete scalabile e ad alta larghezza di banda.
Esistono due possibili implementazioni:
- **Fully non-blocking**: Ogni livello raddoppia il numero di collegamenti rispetto al livello precedente. Tuttavia questo richiede uno switch radice con $N \times N$ porte.

### 19. Latenza e bandwidth della rete di ORFEO
La latenza della rete di ORFEO è di 1.35 microsecondi, mentre la bandwidth è di 12Gb/s.

### 20. Instructions Per Cycle (IPC)
L'IPC è il numero medio di istruzioni eseguite per ciclo di clock. Risulta utile per valutare quanto stiamo sfruttando le capacità super-scalari del nostro processore.

### 21. Descrivi l'architettura di Von Neumann
L'architettura di Von Neumann è caratterizzata da un'unità di controllo, un'unità aritmetico-logica, una memoria centrale e un'unità di input/output. L'unità di controllo legge le istruzioni dalla memoria centrale e le esegue sull'unità aritmetico-logica. L'unità di input/output gestisce l'interazione con l'esterno.

### 22. Quali sono le componenti di un processore?
Le componenti di un processore sono:
- **Unità di controllo**: legge le istruzioni dalla memoria e le esegue.
- **Unità aritmetico-logica**: esegue le operazioni aritmetiche e logiche.
- **Registri**: memorizzano temporaneamente i dati e le istruzioni.
- **Memoria cache**: memorizza temporaneamente i dati e le istruzioni più frequentemente utilizzati.

### 24. Cos'è l'Instruction Set Architecture (ISA)?
L'ISA è l'insieme delle istruzioni che un processore è in grado di eseguire. L'ISA definisce il set di istruzioni, i registri, le modalità di indirizzamento e le modalità di esecuzione delle istruzioni.

### 25. Enuncia la legge di Moore
La legge di Moore afferma che il numero di transistor all'interno di un circuito integrato raddoppia ogni 18-24 mesi.

### 26. Cos'è il memory wall?
Il memory wall è il divario tra la velocità di calcolo del processore e la velocità di accesso alla memoria. Il memory wall è dovuto al fatto che la velocità di calcolo dei processori è aumentata più rapidamente della velocità di accesso alla memoria.

### 27. Cosa si intend per Dennard scaling?
La Dennard scaling afferma che la potenza dissipata da un processore rimane costante al diminuire della dimensione dei transistor.
$$
P = C \times V^2 \times f
$$

### 28. Quali componenti erano presenti assieme ad un vecchio processore e quali sono state integrate nel processore moderno?
Con un vecchio processore erano presenti:
- **Northbridge**: gestiva la comunicazione tra il processore e la memoria.
- **Southbridge**: gestiva la comunicazione tra il processore e i dispositivi di I/O, anche noto come *chipset*.
In un processore moderno, le funzionalità del Northbridge sono state integrate nel processore stesso. Pertanto l'unico chip rimasto è il Southbridge.

### 29. Quali sono le differenze tra UMA e NUMA?
Nell'architettura UMA (Uniform Memory Access) tutti i processori accedono alla memoria con la stessa latenza. Nell'architettura NUMA (Non-Uniform Memory Access) i processori accedono alla memoria con latenze diverse.

### 30. Quali sono le difficoltà delle architetture multi-core?
Le difficoltà delle architetture multi-core sono:
- Necessità di parallelizzare i programmi.
- **Memory bandwidth**: il multi-core aggrava il memory wall.
- **Cache coherence**: i core condividono la cache, quindi è necessario mantenere la coerenza dei dati.

### 31. Come funziona il processo di compilazione? 
Il processo di compilazione è diviso in quattro fasi:
- **Preprocessing**: espande le direttive di preprocessore.
- **Compilazione**: traduce il codice sorgente in codice oggetto. Operazione effettuata dal front-end del compilatore.
- **Assembly**: traduce il codice oggetto in codice macchina. Operazione effettuata dal back-end del compilatore.
- **Linking**: risolve i riferimenti tra i vari moduli del programma.

### 32. Cos'è il loop unrolling?
Il loop unrolling è una tecnica di ottimizzazione del compilatore che consiste nel sostituire un ciclo con un numero fisso di iterazioni con più copie del corpo del ciclo. Il loop unrolling riduce il numero di istruzioni di salto e aumenta il parallelismo a livello di istruzione.

### 33. Cos'è il loop tiling?
Il loop tiling è una tecnica di ottimizzazione del compilatore che consiste nel dividere un ciclo in blocchi più piccoli, chiamati tile. Il loop tiling riduce il numero di cache miss e aumenta il parallelismo a livello di dati.

### 34. Cos'è il memory aliasing?
Il memory aliasing si verifica quando due o più puntatori fanno riferimento alla stessa area di memoria. Il memory aliasing previene ulteriori ottimizzazioni del compilatore.
Inoltre, causa problemi di coerenza della cache, forzando le *cache line* a essere flaggate come non condivise. XXX

### 35. Quali livelli di cache sono presenti in un processore?
I livelli di cache presenti in un processore sono:
- **L1 cache**: cache più piccola e più veloce, generalmente divisa in cache per istruzioni e cache per dati. Locata all'interno di ogni core.
- **L2 cache**: cache più grande e più lenta. Locata all'interno di ogni core, ma potenzialmente condivisa tra più core.
- **L3 cache**: cache più grande e più lenta. Condivisa tra più core.

### 37. Cosa si intende per principio di località?
Il principio di località afferma che i programmi tendono ad accedere a un numero limitato di locazioni di memoria in un determinato periodo di tempo. Il principio di località è diviso in due categorie:
- **Località spaziale**: i programmi tendono ad accedere a locazioni di memoria vicine tra loro.
- **Località temporale**: i programmi tendono ad accedere più volte alla stessa locazione di memoria.

### 38. Come funziona il cache mapping?
Il cache mapping è il processo di mappare un blocco di memoria nella cache. Esistono tre tipi di cache mapping:
- **Fully associative**: un blocco di memoria può essere mappato in qualsiasi posizione della cache.
- **Direct mapped**: un blocco di memoria può essere mappato in una sola *cache line*.
- **n-way set associative**: un blocco di memoria può essere mappato in n posizioni della cache.

### 39. Cos'è una cache line?
Una cache line è la più piccola unità di memoria che può essere trasferita tra la memoria principale e la cache. Una cache line è generalmente di 64 byte.

### 40. Cos'è il cache coherence?
Il cache coherence è il problema di mantenere i dati coerenti tra le cache di più core. Il cache coherence è risolto tramite protocolli di coerenza della cache, come il protocollo MESI. Quando una regione di memoria viene acceduta da più core, è necessario mantenere la coerenza dei dati e quando uno dei due core modifica i dati, la modifica deve essere propagata agli altri core.


### 41. Cos'è il protocollo MESI?
Il protocollo MESI è un protocollo di coerenza della cache che definisce quattro stati per ogni blocco di memoria:
- **Modified**: il blocco è stato modificato in questa cache e non è coerente con la memoria principale.
- **Exclusive**: il blocco viene usato soltanto da questo core ed eventuali modifiche non serve vengano propagate.
- **Shared**: il blocco viene utilizzato da più core ed ogni modifica viene propagata.
- **Invalid**: Il valore di questo blocco è stato modificato da un altro core e non è più valido.

### 42. Nello specifico, come viene mappata la memoria in una cache?
La memoria viene mappata in una cache tramite l'indirizzo di memoria. L'indirizzo di memoria è diviso in tre parti:
- **Tag**: identifica il blocco di memoria.
- **Index**: identifica la posizione della cache.
- **Offset**: identifica la posizione all'interno del blocco di memoria.
Nel caso di una cache size pari a $C$ byte $w$-way set associative, la cache è divisa in $C/(w \times B)$ set, ognuno dei quali contiene $w$ linee di cache e la dimensione di ogni cache line è $B$ byte.

### 43. Considerando la presenza della cache, come avvengono le scritture in memoria?
Le scritture in memoria avvengono in due modalità:
- **Write-through**: i dati vengono scritti sia nella cache ed immediatamente nella memoria principale.
- **Write-back**: i dati vengono scritti solo nella cache. Quando la cache-line viene rimpiazzata, i dati vengono scritti nella memoria principale.

### Cosa si intende per strided access?
Lo strided access è un pattern di accesso alla memoria in cui gli elementi di un array sono accessibili tramite un offset costante. Lo strided access può causare cache miss e ridurre le prestazioni. Risulta più problematico in scrittura che in lettura.

### 44. In quali modi si può attraversare la memoria per ridurre i cache miss?
Per ridurre i cache miss si possono utilizzare due strategie:
- **Blocking**: dividere un array in blocchi più piccoli, aumentando la località spaziale.
- **Space-filling curve**: riordinare gli elementi di un array in modo da aumentare la località spaziale tramite una space filling curve. Esempi di space-filling curve sono la Z-order curve e la curva di Peano-Hilbert.

### 45. Cosa sono gli hot fields e cold fields?
Gli hot fields sono i campi di una struttura dati che vengono frequentemente utilizzati. Al contrario, i cold fields sono i campi di una struttura dati che vengono raramente utilizzati. Gli hot fields dovrebbero essere posizionati vicino tra loro in memoria per aumentare la località spaziale.

### 46. Cosa si intende per loop hoisting?
Il loop hoisting è una tecnica di ottimizzazione del compilatore che consiste nel spostare le istruzioni invarianti al di fuori del ciclo. Questo riduce il numero di istruzioni eseguite all'interno del ciclo.

### 47. Cosa si intende per branch prediction?
La branch prediction è una tecnica di ottimizzazione del processore che consiste nel prevedere la direzione di un branch condizionale, il che aiuta a ridurre il numero di istruzioni di salto eseguite. Le tecniche si dividono in:
#### Static branch prediction
- **Always taken / Always not taken**: predizione costante.
- **Predict by Opcode**: predizione basata sull'opcode dell'istruzione. Nel caso di cicli for, si assume che i backward branch siano sempre presi.
- **Profile-guided prediction**: predizione basata su statistiche raccolte durante l'esecuzione del programma ed utilizzate per prevedere il comportamento futuro da parte del compilatore.
#### Dynamic branch prediction


### 48. Cosa si intende per register spill?
Il register spill si verifica quando il numero di variabili locali supera il numero di registri disponibili. In questo caso, alcune variabili vengono salvate in memoria. Il compiler cerca di minimizzare il register spill salvando in memoria le variabili meno utilizzate.

### 49. Cos'è il TLB (Translation Lookaside Buffer)?
The TLB is a memory cache that stores the recent translations of virtual memory to physical memory. It is a part od the MMU (Memory Management Unit) and it is used to reduce the time taken to access the physical memory.
  
### 50. In che maniera si può sfruttare il prefetching?
Il prefetching è una tecnica di ottimizzazione del processore che consiste nel caricare in anticipo i dati in memoria. Il prefetching riduce il tempo di accesso alla memoria e aumenta il parallelismo a livello di istruzione.  
- **Explicit prefetching**: il programmatore specifica manualmente quali dati caricare in memoria.
- **Induced prefetching**: il programmatore induce il prefetching tramite l'accesso a dati in maniera opportuna.


### 51. Quali sono le differenze fra thread e processo?
Un processo è un'istanza di un programma in esecuzione, mentre un thread è un'unità di esecuzione all'interno di un processo. Quando un nuovo processo viene creato tramite la system call `fork()`, viene copiato l'intero spazio di indirizzamento del processo padre. Al contrario, quando un nuovo thread viene creato tramite la system call `pthread_create()`, viene creato un nuovo stack per il thread, ma condividono lo stesso spazio di indirizzamento.


### 52. Quali sono le differenze fra OpenMP e MPI?
OpenMP e MPI sono due librerie per la programmazione parallela, tuttavia la gestione della memoria è differente:
- **OpenMP**: utilizza il modello di shared-memory, in cui tutti i thread condividono la stessa memoria. 
- **MPI**: utilizza il modello di distributed-memory, in cui ogni processo ha la propria memoria.

### 53. OpenMP thread affinity
L'affinità dei thread in OpenMP è la capacità di vincolare un thread a un core specifico, il quale può aumentare le prestazioni del programma.
- **Places**: specifica dove vengono eseguiti i thread: `cores`, `threads`, `sockets`, `numa nodes`.
- **Binding**: specifica come vengono distribuiti i thread: `close`, `spread`, `master`, `none`.

### 54. Cos'è il false sharing?
Il false sharing si verifica quando due thread condividono la stessa cache line, ma scrivono in locazioni di memoria diverse. Il false sharing può causare cache invalidation e ridurre le prestazioni.

### 55. Thread ordering in OpenMP
OpenMP permette di specificare l'ordine di esecuzione dei thread. Utilizzando semplicemente il pragma `#pragma omp parallel` non si ha garanzia sull'ordine di esecuzione dei thread, causando un non determinismo nell'esecuzione. All'interno di un blocco del genere si può utilizzare il pragma `#pragma omp critical` per garantire che solo un thread alla volta possa eseguire il blocco di codice, senza però garantire l'ordine di esecuzione. Per garantire l'ordine di esecuzione si può utilizzare il pragma `#pragma omp ordered`, che garantisce che i thread eseguano il blocco di codice in ordine crescente.
Il pragma `#pragma omp barrier` permette di sincronizzare i thread, garantendo che nessun thread possa proseguire finché tutti i thread non hanno raggiunto il barrier.
Il pragma `#pragma omp master` permette di eseguire un blocco di codice solo dal thread master.

### 56. Specializing execution in OpenMP
Non tutto il codice di una regione parallela deve essere eseguito in parallelo. Per esempio, si può utilizzare il pragma `#pragma omp atomic` per garantire che un'operazione sia eseguita in modo atomico, questo è un caso particolare di `#pragma omp critical`. Il pragma `#pragma omp single` permette di eseguire un blocco di codice solo dal thread master. A differenza di `#pragma omp master`, il quale effettua un controllo solo sul thread id, `#pragma omp single` richiede una maggior sincronizzazione tra i thread. 

### 57. Scheduling in OpenMP
OpenMP permette di specificare il modo in cui i task vengono assegnati ai thread. Il scheduling può essere statico, dinamico o guidato dal programmatore. 
- **Static scheduling**: i task vengono assegnati staticamente ai thread. Questo può causare problemi di load balancing.
- **Dynamic scheduling**: i task vengono assegnati dinamicamente ai thread non appena sono disponibili. Questo può causare overhead.
- **Guided scheduling**: i task vengono assegnati dinamicamente ai thread, ma il numero di task diminuisce ad ogni iterazione. Questo permette di ridurre l'overhead.

### 58. Nested parallelism in OpenMP
OpenMP permette di creare regioni parallele annidate. Il pragma `#pragma omp parallel for collapse(2)` permette di creare un ciclo for annidato, in cui i due cicli vengono eseguiti in parallelo. Il pragma `#pragma omp parallel reduction(+:sum)` permette di eseguire una riduzione in parallelo.

### 59. Cosa si intende per race condition?
Per race condition si intende una situazione in cui il risultato di un programma dipende dall'ordine di esecuzione dei thread. Questo può causare risultati non deterministici e bug difficili da riprodurre.

### 60. Cosa si intende per data race?
Questo fenomeno avviene quando due o più thread accedono contemporaneamente alla stessa locazione di memoria, almeno uno di questi accessi è in scrittura e le operazioni sono non sincronizzate. Questo può causare risultati non deterministici e bug difficili da riprodurre.

### 61. Cos'è la touch-first policy?
La touch-first policy è una politica di allocazione della memoria. Le data pages sono allocate nella memoria fisica più vicina al core fisico che esegue il thread che accede per primo ai dati. Se un singolo thread inizializza tutti i dati, allora tutti i dati risiederanno nella sua memoria e il numero di accessi remoti sarà massimizzato.


