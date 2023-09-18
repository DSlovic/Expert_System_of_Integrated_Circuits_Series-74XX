unit Chip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JvExExtCtrls, JvImage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm2 = class(TForm)
    imgPinoutAndLogic: TJvImage;
    imgPinout: TJvImage;
    imgLogic: TJvImage;
    labDescription: TLabel;
    ESQuery: TFDQuery;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses ESConnectionModule, IC_74xx_U1;

procedure TForm2.FormShow(Sender: TObject);
var
  desc : String;
  Stream: TStream;
  png : TImage;
begin
  self.caption := IC_74xx_U1.ic_74xx_f1.IC;
  with ESQuery do
    begin
      Connection := ESConnection.ESConnection;
      SQL.Clear;
      SQL.Text := 'SELECT description As desc FROM "74xx" WHERE serial_number = :ic';
      ParamByName('ic').AsString := IC_74xx_U1.ic_74xx_f1.IC;
      Active := True;
      desc := FieldByName('desc').AsString;
      labDescription.Caption := desc;
      labDescription.Alignment := taCenter;
      if desc = '' then
        begin
          ShowMessage('Integrated circuit with serial number:' + IC_74xx_U1.ic_74xx_f1.IC + ' is not found.');
          self.Close;
        end;
      SQL.Clear;
      SQL.Text := 'SELECT pinout_and_logic As img, pinout As pinout, logic As logic FROM "74xx" WHERE serial_number = :ic';
      ParamByName('ic').AsString := IC_74xx_U1.ic_74xx_f1.IC;
      Active := True;
      Stream := CreateBlobStream(FieldByName('img'), bmRead);
      imgPinoutAndLogic.Picture.LoadFromStream(Stream);
      Stream := CreateBlobStream(FieldByName('pinout'), bmRead);
      imgPinout.Picture.LoadFromStream(Stream);
      Stream := CreateBlobStream(FieldByName('logic'), bmRead);
      imgLogic.Picture.LoadFromStream(Stream);
    end;
end;

end.
