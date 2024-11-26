program TabelaHash;
//Por William Wollert BSN T28

const TamanhoTabela = 7;
		  LimitePorCampo = 10;
		  MaxPlacasGeradas = 1000;

type
  PElemento = ^TElemento;
  TElemento = record
    Placa: string;
    Proximo: PElemento;
  end;

var Tabela: array[0..TamanhoTabela - 1] of PElemento;
	  PlacasGeradas: array[1..MaxPlacasGeradas] of string;
	  TotalPlacasGeradas, opcao: integer;

// Função Hash multiplicação
function FuncaoHashMult(Placa: string): integer;
var Produto, Peso, i: integer;
begin
  Produto:= 1;
  Peso:= 37;
  for i := 1 to Length(Placa) do
  begin
    if Placa[i] in ['A'..'Z', 'a'..'z'] then
      Produto:= Produto * ((Ord(Placa[i]) - Ord('A') + 1) * Peso)
    else if Placa[i] in ['0'..'9'] then
      Produto := Produto * ((Ord(Placa[i]) - Ord('0') + 1) * Peso);
    Peso:= Peso * 29;
    Produto:= abs((Produto + 7919) mod 10000);
  end;
  FuncaoHashMult:= abs(Produto mod TamanhoTabela);
end;

// Inicializa a Tabela e o Controle de Placas Geradas
procedure InicializarTabela;
var i:integer;
begin
  for i := 0 to TamanhoTabela - 1 do
    Tabela[i]:= nil;
  TotalPlacasGeradas:= 0;
end;

// Verifica se uma placa já foi gerada
function PlacaJaGerada(Placa:string):boolean;
var i:integer;
begin
  for i := 1 to TotalPlacasGeradas do
    if PlacasGeradas[i] = Placa then
    begin
      PlacaJaGerada:=True;
      Exit;
    end;
  PlacaJaGerada:=False;
end;

// Registra uma nova placa gerada
procedure RegistrarPlaca(Placa:string);
begin
  Inc(TotalPlacasGeradas);
  PlacasGeradas[TotalPlacasGeradas]:=Placa;
end;

// Função para gerar uma placa no formato MERCOSUL
function GerarPlaca: string;
var NovaPlaca: string;
begin
  repeat
    NovaPlaca:= '';
    NovaPlaca:= Chr(Ord('A') + Random(26)) + Chr(Ord('A') + Random(26)) + Chr(Ord('A') + Random(26));
    NovaPlaca:= NovaPlaca + Chr(Ord('0') + Random(10));
    NovaPlaca:= NovaPlaca + Chr(Ord('A') + Random(26));
    NovaPlaca:= NovaPlaca + Chr(Ord('0') + Random(10)) + Chr(Ord('0') + Random(10));
  until not PlacaJaGerada(NovaPlaca);
  RegistrarPlaca(NovaPlaca);
  GerarPlaca:= NovaPlaca;
end;

// Adiciona uma Placa na Tabela HASH
procedure AdicionarPlaca(Placa:string);
var Hash,Contador:integer;
  	NovoElemento,Atual:PElemento;
begin
  Hash:= FuncaoHashMult(Placa);
  Contador := 0;
  Atual:= Tabela[Hash];
  while Atual <> nil do
  begin
    Inc(Contador);
    if Atual^.Placa = Placa then
    begin
      Writeln('Placa ', Placa, ' já existe no índice ', Hash);
      Exit;
    end;
    Atual:= Atual^.Proximo;
  end;
  if Contador >= LimitePorCampo then
  begin
    Writeln('Limite de ', LimitePorCampo, ' placas atingido no índice ', Hash);
    Exit;
  end;
  New(NovoElemento);
  NovoElemento^.Placa:= Placa;
  NovoElemento^.Proximo:= Tabela[Hash];
  Tabela[Hash]:= NovoElemento;
  Writeln('Placa ', Placa, ' adicionada no índice ', Hash);
end;

// Remove uma placa específica da tabela hash
procedure RemoverPlaca(Placa:string);
var Hash:integer;
  	Atual,Anterior:PElemento;
begin
  Hash:= FuncaoHashMult(Placa);
  Atual:= Tabela[Hash];
  Anterior:= nil;
  while Atual <> nil do
  begin
    if Atual^.Placa = Placa then
    begin
      if Anterior = nil then
      begin
        Tabela[Hash]:= Atual^.Proximo;
      end
      else
      begin
        Anterior^.Proximo:= Atual^.Proximo;
      end;
      Writeln('Placa ', Placa, ' removida do índice ', Hash, '.');
      Dispose(Atual);
      Exit;
    end;
    Anterior:= Atual;
    Atual:= Atual^.Proximo;
  end;
  Writeln('Placa ', Placa, ' não encontrada na tabela.');
end;

// Escreve a tabela
procedure ExibirTabela;
var i:integer;
  	Atual:PElemento;
begin
  Writeln('Tabela Hash:');
  for i := 0 to TamanhoTabela - 1 do
  begin
    Write(i, ': ');
    Atual:= Tabela[i];
    if Atual = nil then
      Writeln('[vazio]')
    else
    begin
      while Atual <> nil do
      begin
        Write(Atual^.Placa);
        if Atual^.Proximo <> nil then
          Write(' -> ');
        Atual:= Atual^.Proximo;
      end;
      Writeln;
    end;
  end;
end;

// Função para buscar uma placa na tabela hash
function BuscarPlaca(Placa:string):boolean;
var Hash:integer;
  	Atual:PElemento;
begin
  Hash:= FuncaoHashMult(Placa);
  Atual:= Tabela[Hash];
  while Atual <> nil do
  begin
    if Atual^.Placa = Placa then
    begin
      Writeln('Placa ', Placa, ' encontrada no índice ', Hash, '.');
      BuscarPlaca:= True;
      Exit;
    end;
    Atual:= Atual^.Proximo;
  end;
  Writeln('Placa ', Placa, ' não encontrada na tabela.');
  BuscarPlaca:= False;
end;

// Menu Principal
procedure Menu;
var Placa:string;
begin
  repeat
    Writeln('------------------------------------------');
    Writeln('1. Adicionar placa manualmente');
    Writeln('2. Gerar e adicionar placa automaticamente');
    Writeln('3. Exibir tabela');
    Writeln('4. Buscar placa');
    Writeln('5. Remover placa específica');
    Writeln('6. Sair');
    Writeln('------------------------------------------');
    Write('Escolha uma opcao: ');
    Readln(opcao);
    case opcao of
      1:begin
          Write('Digite a placa (formato MERCOSUL): ');
          Readln(Placa);
          if Length(Placa) = 7 then
            AdicionarPlaca(Placa)
          else
            Writeln('Placa inválida.');
        end;
      2:begin
          Placa := GerarPlaca;
          Writeln('Placa gerada: ', Placa);
          AdicionarPlaca(Placa);
        end;
      3:ExibirTabela;
      4:begin
          Write('Digite a placa que deseja buscar: ');
          Readln(Placa);
          BuscarPlaca(Placa);
        end;
      5:begin
          Write('Digite a placa que deseja remover: ');
          Readln(Placa);
          RemoverPlaca(Placa);
        end;
      6:Writeln('Encerrando programa...');
      	else
        	Writeln('Opção inválida!');
    end;
    Writeln;
  until opcao = 6;
end;

// Programa Principal
begin
  Randomize;
  InicializarTabela;
  Menu;
end.