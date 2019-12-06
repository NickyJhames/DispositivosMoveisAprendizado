object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 305
  Width = 215
  object fdConn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    AfterConnect = fdConnAfterConnect
    Left = 16
    Top = 16
  end
  object fdUsuario: TFDQuery
    Connection = fdConn
    SQL.Strings = (
      'select * from usuario')
    Left = 72
    Top = 16
  end
  object FDQuery1: TFDQuery
    Connection = fdConn
    Left = 136
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 88
    Top = 136
  end
end
