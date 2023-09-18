unit IC_74xx_U1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat, Vcl.ExtCtrls, JvExStdCtrls, JvButton, JvCtrls,
  Vcl.Imaging.pngimage, JvExExtCtrls, JvImage;

type
  Tic_74xx_f1 = class(TForm)
    ESQuery: TFDQuery;
    RB1: TRadioButton;
    BTNext: TButton;
    imgBack: TJvImage;
    RB2: TRadioButton;
    RB3: TRadioButton;
    RB4: TRadioButton;
    RB5: TRadioButton;
    RB6: TRadioButton;
    RB7: TRadioButton;
    RB8: TRadioButton;
    RB9: TRadioButton;
    RB10: TRadioButton;
    RB11: TRadioButton;
    RB12: TRadioButton;
    RB13: TRadioButton;
    RB14: TRadioButton;
    RB15: TRadioButton;
    PanelCaption: TPanel;
    RB16: TRadioButton;
    DescPanel: TPanel;
    LabDesc: TLabel;
    procedure RB1Click(Sender: TObject);
    procedure BTNextClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    IC : String;
  end;

var
  ic_74xx_f1: Tic_74xx_f1;
  arrRB: array[1..100] of TRadioButton;
  layers, pathById: array[1..10] of integer;
  layerCounter : integer;
  totalRadioBtn: integer;
  lastLayerTextForTable, lastLayerTextForName : String;
  answerRB, firstRB : TRadioButton;

implementation

{$R *.dfm}

uses ESConnectionModule, Chip;

function btnEnaDis(obj: TRadioButton; next : TButton): TButton;
  begin
    if obj.Checked = true then
      begin
        next.Enabled := true;
      end
    else
      begin
        next.Enabled := false;

      end;

  end;


procedure Tic_74xx_f1.BTNextClick(Sender: TObject);
var
  brOpcija : integer;
  brojac, listExt, radioStartOnLayer, startRadioBtnCreationNum, lastId, lastIdCheker, realBrojac, iterations, inBrojac : integer;
  nameRb, layerTextForTable, layerTextForName, layerTextForLastId, lastLayerTextForLastId, newNameRb : String;
begin
  if answerRB.Caption[1] + answerRB.Caption[2] = '74' then
    begin
      IC := answerRB.Caption;
      Chip.Form2.Show;
    end
  else
    begin
      layerTextForTable := '_l' + IntToStr(layerCounter);
      layerTextForName := 'l' + IntToStr(layerCounter) + '_';
      if layerCounter = 1 then layerTextForLastId := firstRB.Caption + '_id'
      else layerTextForLastId := 'l' + IntToStr(layerCounter - 1) + '_id';
      if layerCounter <= 2 then lastLayerTextForLastId := firstRB.Caption + '_id'
      else lastLayerTextForLastId := 'l' + IntToStr(layerCounter - 2) + '_id';


      layerCounter := layerCounter + 1;
      brojac := 1;
      if layerCounter = 1 then
        begin
          RB1.Visible := false;
          RB2.Visible := false;
          RB3.Visible := false;
          RB4.Visible := false;
          RB5.Visible := false;
          RB6.Visible := false;
          RB7.Visible := false;
          RB8.Visible := false;
          RB9.Visible := false;
          RB10.Visible := false;
          RB11.Visible := false;
          RB12.Visible := false;
          RB13.Visible := false;
          RB14.Visible := false;
          RB15.Visible := false;
          RB16.Visible := false;
          layerTextForTable := '';
          PanelCaption.Caption := 'add additional attributes to ' + firstRB.Caption;
        end
       else
         begin
         radioStartOnLayer := totalRadioBtn - layers[(layerCounter - 1)];
           while brojac <= layers[layerCounter - 1] do
            begin
              //self.caption := IntToStr(layers[layerCounter - 1]);
              arrRB[radioStartOnLayer + brojac].Visible := false;
              brojac := brojac + 1;
            end;
         end;
      brojac := 1;
      BTNext.Enabled := false;
      with ESQuery do
        begin
          Connection := ESConnection.ESConnection;
          SQL.Clear;
          SQL.Text := 'SELECT COUNT (*) As brOpcija FROM "' + firstRB.Caption + layerTextForTable + '"';
          Active := True;
          brOpcija := FieldByName('brOpcija').AsInteger;
          SQL.Clear;
          SQL.Text := 'SELECT MAX(id) As iterations FROM "' + firstRB.Caption + layerTextForTable + '"';
          Active := True;
          iterations := FieldByName('iterations').AsInteger;
          if layerCounter = 2 then
            begin
              //self.Caption := lastLayerTextForName;
              SQL.Text := 'SELECT id As lastIdCheker FROM "' + firstRB.Caption + lastLayerTextForTable + '" WHERE ' + lastLayerTextForName + 'name =  :ime';
              ParamByName('ime').AsString := answerRB.Caption;
              Active := True;
              lastIdCheker := FieldByName('lastIdCheker').AsInteger;
              //self.Caption := IntToStr(lastIdCheker) + '$' +firstRB.Caption + lastLayerTextForTable + '$' +lastLayerTextForName;
              pathById[layerCounter] := lastIdCheker;
            end
          else if layerCounter > 2 then
            begin
              //self.Caption := lastLayerTextForName;
              SQL.Text := 'SELECT id As lastIdCheker FROM "' + firstRB.Caption + lastLayerTextForTable + '" WHERE ' + lastLayerTextForName + 'name =  :ime AND "' + lastLayerTextForLastId + '" = ' + IntToStr(pathById[layerCounter - 1]);
              ParamByName('ime').AsString := answerRB.Caption;
              Active := True;
              lastIdCheker := FieldByName('lastIdCheker').AsInteger;
              //self.Caption := IntToStr(lastIdCheker) + '$' +firstRB.Caption + lastLayerTextForTable + '$' +lastLayerTextForName;
              pathById[layerCounter] := lastIdCheker;
            end;
        end;
        startRadioBtnCreationNum := totalRadioBtn;
        if layerCounter = 1 then
        begin
          startRadioBtnCreationNum := 0;
          totalRadioBtn := totalRadioBtn + brOpcija;
          layers[layerCounter] := brOpcija;
        end;
        realBrojac := 1;
        while brojac <= iterations +1 do
          begin
               with ESQuery do
                 begin
                   Connection := ESConnection.ESConnection;
                   SQL.Clear;
                    if firstRB.Caption + layerTextForTable = 'gate' then
                      begin
                        SQL.Text := 'SELECT type_name As name FROM gate WHERE id = ' + IntToStr(brojac - 1);
                        Active := True;
                        nameRb := FieldByName('name').AsString;
                      end
                    else if layerCounter = 1 then
                      begin
                        SQL.Text := 'SELECT type_name As name FROM "'+answerRB.Caption+'" WHERE id = ' + IntToStr(brojac);
                        Active := True;
                        nameRb := FieldByName('name').AsString;
                      end
                    else
                      begin
                        SQL.Clear;
                        SQL.Text := 'SELECT ' + layerTextForName + 'name As name, "' + layerTextForLastId + '" As lastId FROM "' + firstRB.Caption + layerTextForTable + '" WHERE id = ' + IntToStr(brojac);
                        Active := True;
                        nameRb := FieldByName('name').AsString;
                        lastId := FieldByName('lastId').AsInteger;
                      end;
                 end;
                 //self.caption := self.caption + '$' + IntToStr(lastId);
            if (lastIdCheker = lastId) and (layerCounter <> 1) and (nameRb <> '')then
              begin
                if nameRb[1] + nameRb[2] = '74' then
                  begin
                    while inBrojac < nameRb.Length do
                      begin
                        inBrojac := inBrojac + 1;
                        if nameRb[inBrojac] = '|' then
                          begin
                            arrRB[startRadioBtnCreationNum + realBrojac] := TRadioButton.Create(Self);
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Charset := ANSI_CHARSET;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Size := 9;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Name := RB1.Font.Name;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Color := COLOR_HIGHLIGHT;
                            if realBrojac = 1 then
                              begin
                                arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                                arrRB[startRadioBtnCreationNum + realBrojac].Top := RB1.Top;
                              end
                            else
                              begin
                                arrRB[startRadioBtnCreationNum + realBrojac].Left := arrRB[startRadioBtnCreationNum + realBrojac - 1].Left + arrRB[startRadioBtnCreationNum + realBrojac - 1].Width + 10;
                                arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top;
                              end;
                            arrRB[startRadioBtnCreationNum + realBrojac].Caption := newNameRb;
                            arrRB[startRadioBtnCreationNum + realBrojac].OnClick := RB1Click;
                            arrRB[startRadioBtnCreationNum + realBrojac].Height := 35;
                            arrRB[startRadioBtnCreationNum + realBrojac].Parent := self;
                            arrRB[startRadioBtnCreationNum + realBrojac].WordWrap := true;
                            realBrojac := realBrojac + 1;
                            newNameRb := '';
                          end
                        else newNameRb := newNameRb + nameRb[inBrojac];
                        if inBrojac = nameRb.Length then
                           begin
                            arrRB[startRadioBtnCreationNum + realBrojac] := TRadioButton.Create(Self);
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Charset := ANSI_CHARSET;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Size := 9;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Name := RB1.Font.Name;
                            arrRB[startRadioBtnCreationNum + realBrojac].Font.Color := COLOR_HIGHLIGHT;
                            if realBrojac = 1 then
                              begin
                                arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                                arrRB[startRadioBtnCreationNum + realBrojac].Top := RB1.Top;
                              end
                            else
                              begin
                                arrRB[startRadioBtnCreationNum + realBrojac].Left := arrRB[startRadioBtnCreationNum + realBrojac - 1].Left + arrRB[startRadioBtnCreationNum + realBrojac - 1].Width + 10;
                                arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top;
                              end;
                            arrRB[startRadioBtnCreationNum + realBrojac].Caption := newNameRb;
                            arrRB[startRadioBtnCreationNum + realBrojac].OnClick := RB1Click;
                            arrRB[startRadioBtnCreationNum + realBrojac].Height := 35;
                            arrRB[startRadioBtnCreationNum + realBrojac].Parent := self;
                            arrRB[startRadioBtnCreationNum + realBrojac].WordWrap := true;
                            realBrojac := realBrojac + 1;

                           end;
                      end;
                  end
                  else
                  begin
                    arrRB[startRadioBtnCreationNum + realBrojac] := TRadioButton.Create(Self);
                    arrRB[startRadioBtnCreationNum + realBrojac].Font.Charset := ANSI_CHARSET;
                    arrRB[startRadioBtnCreationNum + realBrojac].Font.Size := 9;
                    arrRB[startRadioBtnCreationNum + realBrojac].Font.Name := RB1.Font.Name;
                    arrRB[startRadioBtnCreationNum + realBrojac].Font.Color := COLOR_HIGHLIGHT;
                    if realBrojac = 1 then
                      begin
                        arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                        arrRB[startRadioBtnCreationNum + realBrojac].Top := RB1.Top;
                      end
                    else
                      begin
                        arrRB[startRadioBtnCreationNum + realBrojac].Left := arrRB[startRadioBtnCreationNum + realBrojac - 1].Left + arrRB[startRadioBtnCreationNum + realBrojac - 1].Width + 10;
                        arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top;
                      end;
                    if arrRB[startRadioBtnCreationNum + realBrojac].Left + arrRB[startRadioBtnCreationNum + realBrojac].Width >= self.Width then
                      begin
                        arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top + 35;
                        arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                      end;
                    arrRB[startRadioBtnCreationNum + realBrojac].Caption := nameRb;
                    arrRB[startRadioBtnCreationNum + realBrojac].OnClick := RB1Click;
                    arrRB[startRadioBtnCreationNum + realBrojac].Height := 35;
                    arrRB[startRadioBtnCreationNum + realBrojac].Parent := self;
                    arrRB[startRadioBtnCreationNum + realBrojac].WordWrap := true;
                    realBrojac := realBrojac + 1;
                  end;
              end;
            if (layerCounter = 1) and (nameRb <> '') then
              begin
                arrRB[startRadioBtnCreationNum + realBrojac] := TRadioButton.Create(Self);
                arrRB[startRadioBtnCreationNum + realBrojac].Font.Charset := ANSI_CHARSET;
                arrRB[startRadioBtnCreationNum + realBrojac].Font.Size := 9;
                arrRB[startRadioBtnCreationNum + realBrojac].Font.Name := RB1.Font.Name;
                arrRB[startRadioBtnCreationNum + realBrojac].Font.Color := COLOR_HIGHLIGHT;
                if realBrojac = 1 then
                  begin
                    arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                    arrRB[startRadioBtnCreationNum + realBrojac].Top := RB1.Top;
                  end
                else
                  begin
                    arrRB[startRadioBtnCreationNum + realBrojac].Left := arrRB[startRadioBtnCreationNum + realBrojac - 1].Left + arrRB[startRadioBtnCreationNum + realBrojac - 1].Width + 10;
                    arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top;
                  end;
                if arrRB[startRadioBtnCreationNum + realBrojac].Left + arrRB[startRadioBtnCreationNum + realBrojac].Width >= self.Width then
                  begin
                    arrRB[startRadioBtnCreationNum + realBrojac].Top := arrRB[startRadioBtnCreationNum + realBrojac - 1].Top + 35;
                    arrRB[startRadioBtnCreationNum + realBrojac].Left := RB1.Left;
                  end;
                arrRB[startRadioBtnCreationNum + realBrojac].Caption := nameRb;
                arrRB[startRadioBtnCreationNum + realBrojac].OnClick := RB1Click;
                arrRB[startRadioBtnCreationNum + realBrojac].Height := 35;
                arrRB[startRadioBtnCreationNum + realBrojac].Parent := self;
                arrRB[startRadioBtnCreationNum + realBrojac].WordWrap := true;
                realBrojac := realBrojac + 1;
              end;
            brojac := brojac + 1;
          end;
          lastLayerTextForTable := layerTextForTable;
          if layerCounter = 1 then lastLayerTextForName := 'type_'
          else
          begin
            totalRadioBtn := totalRadioBtn + realBrojac - 1;
            lastLayerTextForName := layerTextForName;
            layers[layerCounter] := realBrojac - 1;
          end;

          imgBack.Enabled := true;
          imgBack.Picture := imgBack.Pictures.PicDown;
          LabDesc.Visible := false;
    end;
end;


procedure Tic_74xx_f1.imgBackClick(Sender: TObject);
var
  brojac : integer;
begin
  imgBack.Picture := imgBack.Pictures.PicDown;
  BTNext.Enabled := false;
  if layerCounter - 1 = 0 then
    begin
      RB1.Visible := true;
      RB2.Visible := true;
      RB3.Visible := true;
      RB4.Visible := true;
      RB5.Visible := true;
      RB6.Visible := true;
      RB7.Visible := true;
      RB8.Visible := true;
      RB9.Visible := true;
      RB10.Visible := true;
      RB11.Visible := true;
      RB12.Visible := true;
      RB13.Visible := true;
      RB14.Visible := true;
      RB15.Visible := true;
      RB16.Visible := true;
      imgBack.Enabled := false;
      LabDesc.Visible := false;
      imgBack.Picture := imgBack.Pictures.PicDisabled;
      PanelCaption.Caption := 'Choose integrated circuit';
    end;

      brojac := 1;
      while brojac <= layers[layerCounter] do
        begin
          arrRB[totalRadioBtn - layers[layerCounter] + brojac].Destroy;
          brojac := brojac + 1;
        end;
        totalRadioBtn := totalRadioBtn - layers[layerCounter];
        brojac := 1;
      while brojac <= layers[layerCounter - 1] do
        begin
          arrRB[totalRadioBtn - layers[layerCounter - 1] + brojac].Visible := true;
          brojac := brojac + 1;
        end;

  if layerCounter = 2 then
  begin
   lastLayerTextForName := 'type_';
   lastLayerTextForTable := '';
  end
  else
    begin
      lastLayerTextForName := 'l' + IntToStr(layerCounter - 2) + '_';
      lastLayerTextForTable := '_l' + IntToStr(layerCounter - 2);
    end;
  layers[layerCounter] := 0;
  layerCounter := layerCounter - 1;
  //self.Caption := IntToStr(layerCounter);
end;

procedure Tic_74xx_f1.RB1Click(Sender: TObject);
var
 desc : String;
begin
  btnEnaDis(Sender AS TRadioButton, BTNext);
  answerRB := (Sender AS TRadioButton);
  if layerCounter = 0 then firstRB := answerRB;
  if (layerCounter <> 0) AND (answerRB.Caption[1] + answerRB.Caption[2] <> '74') then
    begin
      with ESQuery do
        begin
          Connection := ESConnection.ESConnection;
          SQL.Clear;
          SQL.Text := 'SELECT desc As desc FROM Description WHERE name = "' + answerRB.Caption + '"';
          Active := True;
          desc := FieldByName('desc').AsString;
        end;
        LabDesc.Caption := desc;
        LabDesc.Visible := true;
    end else LabDesc.Visible := false;
end;

end.
