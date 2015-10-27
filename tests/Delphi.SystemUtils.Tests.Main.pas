unit Delphi.SystemUtils.Tests.Main;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TMainTests = class(TObject) 
  public
  end;

implementation


initialization
  TDUnitX.RegisterTestFixture(TMainTests);
end.
