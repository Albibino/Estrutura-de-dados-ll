program ArvoreBinaria;
//Por: William Wollert T28

type ptrno = ^No;
	no = record
  num: integer;
  esq, dir: ptrno;
end;

var raiz: ptrno;

//Função para criar um novo nó
function novono(num: integer): ptrno;
	var temp: ptrno;
begin
  new(temp);
  temp^.num := num;
  temp^.esq := nil;
  temp^.dir := nil;
  novono := temp;
end;

//Função para inserir um número na árvore binária
procedure insereno(var raiz: ptrno; num: integer);
begin
  if raiz = nil then
		raiz := novono(num)
  else if num < raiz^.num then
    insereno(raiz^.esq, num)
  else if num > raiz^.num then
    insereno(raiz^.dir, num)
  else
    writeln('Número já existe na árvore.');
end;

//Função para buscar um num na árvore binária
function buscanum(raiz: ptrno; num: integer): ptrno;
begin
  if (raiz = nil) or (raiz^.num = num) then
    buscanum := raiz
  else if num < raiz^.num then
    buscanum := buscanum(raiz^.esq, num)
  else
    buscanum := buscanum(raiz^.dir, num);
end;

//Função para encontrar o nó mínimo
function minno(raiz: ptrno): ptrno;
begin
  while raiz^.esq <> nil do
    raiz := raiz^.esq;
  minno := raiz;
end;

//Função para remover um número da árvore binária
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

//Função para exibir a árvore em ordem
procedure emordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    emordem(raiz^.esq);
    write(raiz^.num, ' ');
    emordem(raiz^.dir);
  end;
end;

//Função para exibir a árvore em pré-ordem
procedure preordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    write(raiz^.num, ' ');
    preordem(raiz^.esq);
    preordem(raiz^.dir);
  end;
end;

//Função para exibir a árvore em pós-ordem
procedure posordem(raiz: ptrno);
begin
  if raiz <> nil then begin
    posordem(raiz^.esq);
    posordem(raiz^.dir);
    write(raiz^.num, ' ');
  end;
end;

//Função para calcular a altura da árvore
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

//Função para encontrar o nível de um elemento
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

//Função para escrever e contar os nós folhas
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

//Função para contar o número total de nós
function contano(raiz: ptrno): integer;
begin
  if raiz = nil then
    contano := 0
  else
    contano := 1 + contano(raiz^.esq) + contano(raiz^.dir);
end;

//Função para verificar se a árvore auxiliar é completa
function completaauxiliar(raiz: ptrno; index: integer; numeronos: integer): boolean;
begin
  if raiz = nil then
    completaauxiliar := true
  else if index >= numeronos then
    completaauxiliar := false
  else
    completaauxiliar := completaauxiliar(raiz^.esq, 2*index + 1, numeronos) and completaauxiliar(raiz^.dir, 2*index + 2, numeronos);
end;

//Função para verificar se a árvore é completa
function arvcompleta(raiz: ptrno): boolean;
	var numeronos: integer;
begin
  numeronos := contano(raiz);
  arvcompleta := completaauxiliar(raiz, 0, numeronos);
end;

//Função para destruir a árvore
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
    writeln('1. Insere nó');
    writeln('2. Buscar Elemento');
    writeln('3. Remover Elemento');
    writeln('4. Exibir em ordem (in-ordem)');
    writeln('5. Exibir pré-ordem');
    writeln('6. Exibir pós-ordem');
    writeln('7. Verificar altura da árvore');
    writeln('8. Verificar nível de um elemento');
    writeln('9. Escrever e contar os nós folhas');
    writeln('10. Informar se a árvore é completa');
    writeln('11. Destroir Árvore');
    writeln('---------------------------------------');
    writeln('Escolha uma opcao: ');
    write('--> ');
    readln(op);
    case op of
      1: begin
        clrscr;
        write('Digite o número para inserir: ');
        readln(num);
        insereno(raiz, num);
      end;
      2: begin
        clrscr;
        write('Digite o número para buscar: ');
        readln(num);
        if buscanum(raiz, num) <> nil then
          writeln('Número encontrado!')
        else
          writeln('Número não encontrado.');
      end;
      3: begin
        clrscr;
        write('Digite o número para remover: ');
        readln(num);
        removeno(raiz, num);
      end;
      4: begin
        clrscr;
        writeln('Árvore em ordem (in-ordem):');
        emordem(raiz);
        writeln;
      end;
      5: begin
        clrscr;
        writeln('Árvore em pré-ordem:');
        preordem(raiz);
        writeln;
      end;
      6: begin
        clrscr;
        writeln('Árvore em pós-ordem:');
        posordem(raiz);
        writeln;
      end;
      7: begin
        clrscr;
        writeln('Altura da árvore: ', alturaarv(raiz));
      end;
      8: begin
        clrscr;
        write('Digite o num para verificar o nível: ');
        readln(num);
        nivel := nivelno(raiz, num, 0);
        if nivel <> -1 then
          writeln('O nível do elemento ', num, ' é: ', nivel)
        else
          writeln('Elemento não encontrado na árvore.');
      end;
      9: begin
        clrscr;
        writeln('Nós folhas:');
        totfolhas := contafolha(raiz);
        writeln;
        writeln('Total de nós folhas: ', totfolhas);
      end;
      10: begin
        clrscr;
        if arvcompleta(raiz) then
          writeln('A árvore é completa.')
        else
          writeln('A árvore não é completa.');
      end;
      11: begin
        clrscr;
        destroiarv(raiz);
        writeln('Árvore destruída.');
      end;
    end;
	until op = 0;
end.