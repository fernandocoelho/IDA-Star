vizinhos(a,[[z,75],[s,140],[t,118]]).
vizinhos(b,[[g,90],[p,101],[f,211],[u,85]]).
vizinhos(c,[[d,120],[p,138],[r,146]]).
vizinhos(d,[[c,120],[m,75]]).
vizinhos(e,[[h,86]]).
vizinhos(f,[[s,99],[b,211]]).
vizinhos(g,[[b,90]]).
vizinhos(h,[[e,86],[u,98]]).
vizinhos(i,[[n,87],[v,92]]).
vizinhos(l,[[m,70],[t,111]]).
vizinhos(m,[[l,70],[d,75]]).
vizinhos(n,[[i,87]]).
vizinhos(o,[[z,71],[s,151]]).
vizinhos(p,[[c,138],[r,97],[b,101]]).
vizinhos(r,[[c,146],[p,97],[s,80]]).
vizinhos(s,[[a,140],[o,151],[r,80],[f,99]]).
vizinhos(t,[[a,118],[l,111]]).
vizinhos(u,[[b,85],[h,98],[v,142]]).
vizinhos(v,[[u,142],[i,92]]).
vizinhos(z,[[a,75],[o,71]]).

pos(a,20,160).
pos(b,230,40).
pos(c,150,20).
pos(d,90,20).
pos(e,290,20).
pos(f,160,140).
pos(g,210,20).
pos(h,290,60).
pos(i,240,180).
pos(l,70,60).
pos(m,80,40).
pos(n,190,200).
pos(o,40,210).
pos(p,170,70).
pos(r,110,100).
pos(s,100,140).
pos(t,20,90).
pos(u,250,60).
pos(v,270,120).
pos(z,30,190).

h(Ec,Ef,H):-
	pos(Ec,X1,Y1),
	pos(Ef,X2,Y2),
	H is sqrt(((X2 - X1)*(X2 - X1)) + ((Y2 - Y1)*(Y2 - Y1))).

possui_estado(t(_,_,[ r(_,E) | _ ]),E).

trajetoria_impressa(t(_,_,T)):-
	nodos_impressos(T).

nodos_impressos([ r(raiz,Nodo) ]):-
	write('Estado Inicial: '),
	write(Nodo),
	write('. \n').

nodos_impressos([ r(Op,Nodo) | Resto ]):-
	nodos_impressos(Resto),
	write(Op),
	write(' a cidade: '),
	write(Nodo),
	write('. \n').

ida(Ei,Ef):-
	h(Ei,Ef,Limite),
	busca_ida([ t(Limite,0,[ r(raiz,Ei) ]) ],Ef,Limite,Trajetoria),
	trajetoria_impressa(Trajetoria).

busca_ida([ Solucao | _ ],Ef,_,Solucao):-
	possui_estado(Solucao,Ef),
	!.

busca_ida([ Trajetoria | Pilha ],Ef,Limite,Solucao):-
	adjacentes(Trajetoria,Ef,NovasTrajetorias),
	inseridas_pilha(NovasTrajetorias,Pilha,Limite,NovaPilha),
	busca_ida(NovaPilha,Ef,Limite,Solucao),
	!.

busca_ida([ Trajetoria | _ ],Ef,Limite,Solucao):-
	adjacentes(Trajetoria,Ef,NovasTrajetorias),
	menor_trajetoria(NovasTrajetorias,Limite,t(F,_,T)),
	raiz(T,Ei),
	h(Ei,Ef,H),
	busca_ida([ t(H,0,[ r(raiz,Ei) ]) ],Ef,F,Solucao).

adjacentes( t(F,G,[ r(Op,E) | Resto ]),Ef,NovasTrajetorias):-
	vizinhos(E,V),
	trajetorias(t(F,G,[ r(Op,E) | Resto ]),V,Ef,NovasTrajetorias).

trajetorias(_, [], _, []).

trajetorias(t(F,G,T), [ [Pe,Custo] | Resto ], Ef, [ t(F2,G2,[ r('vai para',Pe) | T ]) | Outras ]):-
	h(Pe,Ef,H),
	G2 is G + Custo,
	F2 is H + G2,
	not(produz_ciclo(Pe,T)),
	trajetorias(t(F,G,T), Resto, Ef, Outras),
	!.
	
trajetorias(T, [ _ | Resto ],Ef, Trajetorias):-
	trajetorias(T,Resto,Ef,Trajetorias).

produz_ciclo(E,[ r(_,E) | _ ]).

produz_ciclo(E,[ _ | Resto ]):-
	produz_ciclo(E,Resto).

menor_trajetoria([ t(F,G,T) ],Limite,t(F,G,T)):-
	F > Limite.

menor_trajetoria([ t(F,G,T) | Outras ],Limite,t(F,G,T)):-
	menor_trajetoria(Outras,Limite,t(F2,_,_)),
	F > Limite,
	F < F2,
	!.

menor_trajetoria([ _ | Outras ],Limite,Menor):-
	menor_trajetoria(Outras,Limite,Menor).

raiz([ r(raiz,R) ],R).

raiz([ _ | Resto], R):-
	raiz(Resto,R).

inseridas_pilha([], P, _, P).

inseridas_pilha([ t(F,G,T) | Outras ], Pilha, Limite, [ t(F,G,T) | NovaPilha ]):-
	F =< Limite,
	inseridas_pilha(Outras,Pilha,Limite,NovaPilha),
	!.

inseridas_pilha([ _ | Outras ], Pilha, Limite, NovaPilha):-
	inseridas_pilha(Outras,Pilha,Limite,NovaPilha).

