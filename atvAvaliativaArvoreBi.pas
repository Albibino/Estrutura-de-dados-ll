program ArvoreBinariaUF;
// Por: William Wollert T28 BSN - UNIDAVI

//Tipo nó, que é utilizado tanto para UF quanto para Mun
type
  Ptr = ^Nodo;
  Nodo = record
    nome:string;
    municipios,esq,dir:Ptr;
  end;

var raizUF: Ptr;

//Função apra criar novo nó (UF ou Mun)
function NovoNodo(nome:string):Ptr;
	var novo: Ptr;
begin
	New(novo);
  novo^.nome:= nome;
  novo^.municipios:= nil;
  novo^.esq:= nil;
  novo^.dir:= nil;
  NovoNodo:= novo;
end;

//Procedimento para inserir na arvore principal
procedure Inserir(var raiz:Ptr; nome:string);
begin
  if raiz = nil then
    raiz := NovoNodo(nome)
  else if nome < raiz^.nome then
    Inserir(raiz^.esq, nome)
  else if nome > raiz^.nome then
    Inserir(raiz^.dir, nome);
end;

//Função apra encontrar nó (UF ou mun)
function Encontrar(raiz:Ptr; nome:string):Ptr;
begin
  if (raiz = nil) or (raiz^.nome = nome) then
    Encontrar:= raiz
  else if nome < raiz^.nome then
    Encontrar:= Encontrar(raiz^.esq,nome)
  else
    Encontrar:= Encontrar(raiz^.dir,nome);
end;

//Função para adicionar muni na arvore de muni
procedure AdicionarMunicipio(sigla,municipio:string);
	var uf:Ptr;
begin
  uf := Encontrar(raizUF,sigla);
  if uf = nil then
  begin
    Inserir(raizUF,sigla);
    uf := Encontrar(raizUF,sigla);
  end;
  Inserir(uf^.municipios,municipio);
end;

//Procedimento para remover um nó (UF ou município)
procedure Remover(var raiz: Ptr; nome: string);
  var temp, sucessor: Ptr;
begin
  if raiz = nil then
    Exit;
  if nome < raiz^.nome then
    Remover(raiz^.esq, nome)
  else if nome > raiz^.nome then
    Remover(raiz^.dir, nome)
  else
  begin
    if (raiz^.esq = nil) and (raiz^.dir = nil) then
    begin
      Dispose(raiz);
      raiz := nil;
    end
    else if raiz^.esq = nil then
    begin
      temp := raiz;
      raiz := raiz^.dir;
      Dispose(temp);
    end
    else if raiz^.dir = nil then
    begin
      temp := raiz;
      raiz := raiz^.esq;
      Dispose(temp);
    end
    else
    begin
      sucessor := raiz^.dir;
      while sucessor^.esq <> nil do
        sucessor := sucessor^.esq;      
      raiz^.nome := sucessor^.nome;
      Remover(raiz^.dir, sucessor^.nome);
    end;
  end;
end;


//Procedimento para remover UF quando vazia
procedure RemoverUFVazia(var raiz:Ptr; nome:string);
begin
  if raiz <> nil then
  begin
    if nome < raiz^.nome then
      RemoverUFVazia(raiz^.esq, nome)
    else if nome > raiz^.nome then
      RemoverUFVazia(raiz^.dir, nome)
    else if (raiz^.municipios = nil) then
      Remover(raizUF, nome);                        
  end;
end;

//Função para contar mun
function Contar(raiz: Ptr): integer;
begin
  if raiz = nil then
    Contar:= 0
  else
    Contar:= 1 + Contar(raiz^.esq) + Contar(raiz^.dir);
end;

//Procedimento para escrever a arvore em ordem tipo do nó
procedure ExibirDetalhado(raiz:Ptr; prefixo,tipoNo:string);
begin
  if raiz <> nil then
  begin
    writeln(prefixo, tipoNo, ': ', raiz^.nome);    
    if (raiz^.esq = nil) and (raiz^.dir = nil) then
      writeln(prefixo, '  (Folha)')
    else
    begin
      if raiz^.esq <> nil then
        ExibirDetalhado(raiz^.esq, prefixo + '  ', 'Filho Esquerdo');
      if raiz^.dir <> nil then
        ExibirDetalhado(raiz^.dir, prefixo + '  ', 'Filho Direito');
    end;
  end;
end;

//Procedimento do Menu
procedure Menu;
var opcao: integer;
    sigla, municipio: string;
    uf: Ptr;
begin
  repeat
    writeln;
    writeln('------------------------------');
    writeln('1. Adicionar Municipio');
    writeln('2. Remover Municipio');
    writeln('3. Exibir UFs');
    writeln('4. Exibir Municipios de uma UF');
    writeln('5. Contar Municipios de uma UF');
    writeln('0. Sair');
    writeln('------------------------------');
    write('--> '); 
    readln(opcao);
    case opcao of
      1: begin
           clrscr;
           write('Sigla da UF: '); 
           readln(sigla);
           write('Nome do municipio: '); 
           readln(municipio);
           AdicionarMunicipio(sigla, municipio);
         end;
      2: begin
           clrscr;
           write('Sigla da UF: '); 
           readln(sigla);
           write('Nome do municipio: '); 
           readln(municipio);
           uf := Encontrar(raizUF, sigla);
           if uf <> nil then
           begin
             Remover(uf^.municipios, municipio);
             if uf^.municipios = nil then
               Remover(raizUF, sigla);
           end
           else
             writeln('UF não encontrada!');
         end;
      3: begin
           clrscr;
           if raizUF <> nil then
             ExibirDetalhado(raizUF, '', 'Raiz')
           else
             writeln('Nenhuma UF cadastrada.');
         end;
      4: begin
           clrscr;
           write('Sigla da UF: '); 
           readln(sigla);
           uf := Encontrar(raizUF, sigla);
           if uf <> nil then
           begin
             if uf^.municipios <> nil then
               ExibirDetalhado(uf^.municipios, '  ', 'Raiz')
             else
               writeln('Nenhum município cadastrado para esta UF.');
           end
           else
             writeln('UF não encontrada!');
         end;
      5: begin
           clrscr;
           write('Sigla da UF: '); 
           readln(sigla);
           uf := Encontrar(raizUF, sigla);
           if uf <> nil then writeln('Total de municipios em ', sigla, ': ', Contar(uf^.municipios))
           else writeln('UF não encontrada!');
         end;
    end;
  until opcao = 0;
end;

//Programa principal
begin
  raizUF:= nil;
  Menu;
end.