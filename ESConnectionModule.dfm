object ESConnection: TESConnection
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ESConnection: TFDConnection
    ConnectionName = 'ESVeza'
    Params.Strings = (
      'Database=ES_74xx_ic.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    VendorLib = 'sqlite3.dll'
    Left = 128
    Top = 72
  end
end
