unit uExportar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmExportar = class(TForm)
    Panel1: TPanel;
    Conexao: TFDConnection;
    qryCadastro: TFDQuery;
    dsCadastro: TDataSource;
    DBGrid1: TDBGrid;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    BitBtn2: TBitBtn;
    qryCadastroTIPO: TStringField;
    qryCadastroCPF_CNPJ: TStringField;
    qryCadastroNOME: TStringField;
    qryCadastroDATA_PERMISSAO: TStringField;
    qryCadastroDATA_VALIDADE: TStringField;
    qryCadastroOBJETO: TStringField;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    espacos : String;

    { Public declarations }
  end;

var
  frmExportar: TfrmExportar;

implementation

{$R *.dfm}

function space(x:integer):string;
//
// Retorna X espaços em branco
//
var
  a : integer;
  caracter : string;
begin
 Caracter := '';
 for a := 1 to x do
   caracter := caracter + ' ';
 result := caracter;
end;

function StrZero(Zeros:string;Quant:integer):String;
{Insere Zeros à frente de uma string}
var
I,Tamanho:integer;
aux: string;
begin
  aux := zeros;
  Tamanho := length(ZEROS);
  ZEROS:='';
  for I:=1 to quant-tamanho do
      ZEROS:=ZEROS + '0';
      aux := aux + zeros;
      StrZero := aux;
end;

procedure TfrmExportar.BitBtn2Click(Sender: TObject);
var wproximo,hseque : Integer;
    wdataini,wparc,wnconf,linha,wdocume,tdocu : string;
    wjuros   : Extended;
    F : TextFile;
    wh001, wh002, wh003, wh004,wh005,wh006,
    wh007,wh008,wh009,wh010,wh011,wh012, wd001, wd002,
    wd003, wd004, wd005, wd006, wd007, wt001, wt002, wt003 : String;
begin
    if MessageDlg('Confirma Gerar Aquivo Guaxupe.rem ?',mtConfirmation,[mbYes,MbNo],
       0)= mrNo then
      begin
       close;
       exit;
      end;

       hseque := 0;

//    hearder
        wh001   := '1';
        wh002   := 'MG';
        wh003   := '18663401000197';
        wh004   := '15102024';
        wh005   := '0000000152';
        wh006   := '202410';
        wh007   := '0007';
        wh008   := '202410';
        wh009   := '0006';
        wh010   := '100';
        wh011   := 'ATSENFE';
        wh012   := space(167);   // brancos

        hseque  := hseque + 1;

  qryCadastro.First;

     if qryCadastro.IsEmpty then
       begin
         showmessage('NÃ£o tem registros para gerar');
         qryCadastro.close;
         close;
       end;

  AssignFile(F,'c:\guaxupe.txt');
  Rewrite(F);

  linha := wh001+wh002+wh003+wh004+wh005+wh006+wh007+wh008
           +wh009+wh010+wh011+wh012;

  writeln(F,linha);

  while not qryCadastro.Eof do
     begin

  // DETALHES
             wd001   := '2';
             wd002   := qryCadastroTIPO          .AsString;
             wd003   := qryCadastroCPF_CNPJ      .AsString;
             wd004   := StrZero(Trim(qryCadastroNOME.AsString), (100 - Length(Trim(qryCadastroNOME.AsString))));
             wd005   := qryCadastroDATA_PERMISSAO.AsString;
             wd006   := qryCadastroDATA_VALIDADE .AsString;
             wd007   := StrZero(Trim(qryCadastroOBJETO.AsString), (100 - Length(Trim(qryCadastroOBJETO.AsString))));

  linha  := wd001+wd002+wd003+wd004+wd005+wd006+wd007;

  writeln(F,linha);

  wd001 := '';
  wd002 := '';
  wd003 := '';
  wd004 := '';
  wd005 := '';
  wd006 := '';
  wd007 := '';

  linha := '';

  qryCadastro.Next;

 end;

 // Trailer
   hseque  := hseque + 1;

   wt001   := '9';
   wt002   := '000000007'; //  brancos
   wt003   := space(190); //  brancos

   linha   := wt001+wt002+wt003;

   writeln(F,linha);

   CloseFile(F);

  showmessage('Arquivo guaxupe.txt gerado com sucesso');
  close;
end;

procedure TfrmExportar.FormActivate(Sender: TObject);
begin
  qryCadastro.Open;
end;

end.
