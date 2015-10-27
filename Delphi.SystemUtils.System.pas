unit Delphi.SystemUtils.System;

interface

uses
  SysUtils,
  Classes,
  Spring;

type

  {$REGION 'TNoCountedObject'}
  TNoCountedObject = class(TObject, IInterface)
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
  {$ENDREGION}

  {$REGION 'TAggregatedObject'}
  TAggregatedObject<T: IInterface> = class(TObject, IInterface)
  strict private
    FControllerWeakRef: WeakReference<T>;
  strict protected
    function Controller: T;
  public
    constructor Create(const AController: T);

    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; virtual; stdcall;
    function _Release: Integer; virtual; stdcall;
  end;
  {$ENDREGION}

  {$REGION 'TContainedObject'}
  TContainedObject<T: IInterface> = class(TAggregatedObject<T>, IInterface)
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
  end;
  {$ENDREGION}

implementation

{$REGION 'TAggregatedObject'}
function TAggregatedObject<T>.Controller: T;
begin
  Result := FControllerWeakRef.Target;
end;

constructor TAggregatedObject<T>.Create(const AController: T);
begin
  FControllerWeakRef := WeakReference<T>.Create(AController);
end;

function TAggregatedObject<T>.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := Controller.QueryInterface(IID, Obj);
end;

function TAggregatedObject<T>._AddRef: Integer;
begin
  Result := Controller._AddRef;
end;

function TAggregatedObject<T>._Release: Integer;
begin
  Result := Controller._Release;
end;
{$ENDREGION}

{$REGION 'TContainedObject'}
function TContainedObject<T>.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;
{$ENDREGION}

{$REGION 'TNoCountedObject'}
function TNoCountedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TNoCountedObject._AddRef: Integer;
begin
  Result := -1;
end;

function TNoCountedObject._Release: Integer;
begin
  Result := -1;
end;
{$ENDREGION}

end.