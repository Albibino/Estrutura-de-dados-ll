program ArvoreBinaria;
//Por: William Wollert T28

type ptrno = ^No;
	no = record
  num: integer;
  esq, dir: ptrno;
end;

var raiz: ptrno;

//Fun��o para criar um novo n�
function novono(num: integer): ptrno;
	var temp: ptrno;
begin
  new(temp);
  temp^.num := num;
  temp^.esq := nil;
  temp^.dir := nil;
  novono := temp;
end;

//Fun��o para inserir um n�mero na �rvore bin�ria
procedure insereno(var raiz: ptrno; num: integer);
begin
  if raiz = nil then
		raiz := novono(num)
  else if num < raiz^.num then
    insereno(raiz^.esq, num)
  else if num > raiz^.num then
    insereno(raiz^.dir, num)
  else
    writeln('N�mero j� existe na �rvore.');
end;

//Fun��o para buscar um num na �rvore bin�ria
function buscanum(raiz: ptrno; num: integer): ptrno;
begin
  if (raiz = nil) or (raiz^.num = num) then
    buscanum := raiz
  else if num < raiz^.num then
    buscanum := buscanum(raiz^.esq, num)
  else
    buscanum := buscanum(raiz^.dir, num);
end;

//Fun��o para encontrar o n� m�nimo
function minno(raiz: ptrno): ptrno;
begin
  while raiz^.esq <> nil do
    raiz := raiz^.esq;
  minno := raiz;
end;

//Fun��o para remover um n�mero da �rvore bin�ria
procedure removeno(var raiz: ptrno; num: integer);
	var temp: ptrno;
begin
  if raiz = nil then
    exit
  else if num < raiz^.num then
    removeno(raiz^.esq, num)
  else if num > raiz^.num then
    removeno(raiz^.dir, num)
  else begin
    if (raiz^.esq = nil) then begin
      temp := raiz;
      raiz := raiz^.dir;
      dispose(temp);
    end
    else if (raiz^.dir = nil) then begin
      temp := raiz;
      raiz := raiz^.esq;
      dispose(temp);
    end
    else begin
      temp := minno(raiz^.dir);
      raiz^.num := temp^.num;
      removeno(raiz^.dir, temp^.num);
    end;
  end;
end;

//Fun��o para exibir a �rvore em ordem
procedure emordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    emordem(raiz^.esq);
    write(raiz^.num, ' ');
    emordem(raiz^.dir);
  end;
end;

//Fun��o para exibir a �rvore em pr�-ordem
procedure preordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    write(raiz^.num, ' ');
    preordem(raiz^.esq);
    preordem(raiz^.dir);
  end;
end;

//Fun��o para exibir a �rvore em p�s-ordem
procedure posordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    posordem(raiz^.esq);
    posordem(raiz^.dir);
    write(raiz^.num, ' ');
  end;
end;

//Fun��o para calcular a altura da �rvore
function alturaarv(raiz: ptrno): integer;
	var alturaEsq, alturaDir: integer;
begin
  if raiz = nil then
    alturaarv := 0
  else begin
    alturaEsq := alturaarv(raiz^.esq);
    alturaDir := alturaarv(raiz^.dir);
    if alturaEsq > alturaDir then
      alturaarv := alturaEsq + 1
    else
      alturaarv := alturaDir + 1;
  end;
end;

//Fun��o para encontrar o n�vel de um elemento
function nivelno(raiz: ptrno; num: integer; nivelAtual: integer): integer;
	var nivel: integer;
begin
  if raiz = nil then
    nivelno := -1
  else if raiz^.num = num then
    nivelno := nivelAtual
  else begin
    nivel := nivelno(raiz^.esq, num, nivelAtual + 1);
    if nivel <> -1 then
      nivelno := nivel
    else
      nivelno := nivelno(raiz^.dir, num, nivelAtual + 1);
  end;
end;

//Fun��o para escrever e contar os n�s folhas
function contafolha(raiz: ptrno): integer;
begin
  if raiz = nil then
    contafolha := 0
  else if (raiz^.esq = nil) and (raiz^.dir = nil) then begin
    write(raiz^.num, ' ');
    contafolha := 1;
  end else
    contafolha := contafolha(raiz^.esq) + contafolha(raiz^.dir);
end;

//Fun��o para contar o n�mero total de n�s
function contano(raiz: ptrno): integer;
begin
  if raiz = nil then
    contano := 0
  else
    contano := 1 + contano(raiz^.esq) + contano(raiz^.dir);
end;

//Fun��o para verificar se a �rvore auxiliar � completa
function completaauxiliar(raiz: ptrno; index: integer; numeronos: integer): boolean;
begin
  if raiz = nil then
    completaauxiliar := true
  else if index >= numeronos then
    completaauxiliar := false
  else
    completaauxiliar := completaauxiliar(raiz^.esq, 2*index + 1, numeronos) and completaauxiliar(raiz^.dir, 2*index + 2, numeronos);
end;

//Fun��o para verificar se a �rvore � completa
function arvcompleta(raiz: ptrno): boolean;
	var numeronos: integer;
begin
  numeronos := contano(raiz);
  arvcompleta := completaauxiliar(raiz, 0, numeronos);
end;

//Fun��o para destruir a �rvore
procedure destroiarv(var raiz: ptrno);
begin
  if raiz <> nil then begin
    destroiarv(raiz^.esq);
    destroiarv(raiz^.dir);
    dispose(raiz);
    raiz := nil;
  end;
end;

//Programa principal
var num, op: integer;
		nivel, totfolhas: integer;

begin
  raiz := nil;
	repeat
  	writeln('---------------------------------------');
    writeln('0. Sair');
    writeln('1. Insere n�');
    writeln('2. Buscar Elemento');
    writeln('3. Remover Elemento');
    writeln('4. Exibir em ordem (in-ordem)');
    writeln('5. Exibir pr�-ordem');
    writeln('6. Exibir p�s-ordem');
    writeln('7. Verificar altura da �rvore');
    writeln('8. Verificar n�vel de um elemento');
    writeln('9. Escrever e contar os n�s folhas');
    writeln('10. Informar se a �rvore � completa');
    writeln('11. Destroir �rvore');
    writeln('---------------------------------------');
    writeln('Escolha uma opcao: ');
    write('--> ');
    readln(op);
    case op of
      1: begin
        clrscr;
        write('Digite o n�mero para inserir: ');
        readln(num);
        insereno(raiz, num);
      end;
      2: begin
        clrscr;
        write('Digite o n�mero para buscar: ');
        readln(num);
        if buscanum(raiz, num) <> nil then
          writeln('N�mero encontrado!')
        else
          writeln('N�mero n�o encontrado.');
      end;
      3: begin
        clrscr;
        write('Digite o n�mero para remover: ');
        readln(num);
        removeno(raiz, num);
      end;
      4: begin
        clrscr;
        writeln('�rvore em ordem (in-ordem):');
        emordem(raiz);
        writeln;
      end;
      5: begin
        clrscr;
        writeln('�rvore em pr�-ordem:');
        preordem(raiz);
        writeln;
      end;
      6: begin
        clrscr;
        writeln('�rvore em p�s-ordem:');
        posordem(raiz);
        writeln;
      end;
      7: begin
        clrscr;
        writeln('Altura da �rvore: ', alturaarv(raiz));
      end;
      8: begin
        clrscr;
        write('Digite o num para verificar o n�vel: ');
        readln(num);
        nivel := nivelno(raiz, num, 0);
        if nivel <> -1 then
          writeln('O n�vel do elemento ', num, ' �: ', nivel)
        else
          writeln('Elemento n�o encontrado na �rvore.');
      end;
      9: begin
        clrscr;
        writeln('N�s folhas:');
        totfolhas := contafolha(raiz);
        writeln;
        writeln('Total de n�s folhas: ', totfolhas);
      end;
      10: begin
        clrscr;
        if arvcompleta(raiz) then
          writeln('A �rvore � completa.')
        else
          writeln('A �rvore n�o � completa.');
      end;
      11: begin
        clrscr;
        destroiarv(raiz);
        writeln('�rvore destru�da.');
      end;
    end;
	until op = 0;
end.