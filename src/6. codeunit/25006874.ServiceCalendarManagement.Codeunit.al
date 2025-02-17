codeunit 25006874 "Service Calendar Management"
{

    trigger OnRun()
    begin
    end;

    var
        DateFrom: Date;
        DateTo: Date;
        LocationCode: Code[20];
        SelectedDate: Date;

    [Scope('Internal')]
    procedure FillAddInData(var AddInDataToFill: BigText)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XMLport "25006871";
        TempBlob: Record "99008535" temporary;
        StreamReader: DotNet StreamReader;
    begin
        CLEAR(AddInDataToFill);
        TempBlob.INIT;
        TempBlob.INSERT;
        TempBlob.Blob.CREATEOUTSTREAM(OutStreamData);
        ExportXmlPort.SetSelectedDate(SelectedDate);
        ExportXmlPort.SetLocationCode(LocationCode);
        ExportXmlPort.SetCalendarPeriod(DateFrom, DateTo);
        ExportXmlPort.SETDESTINATION(OutStreamData);
        IF ExportXmlPort.EXPORT THEN BEGIN
            TempBlob.CALCFIELDS(Blob);
            TempBlob.Blob.CREATEINSTREAM(InStreamData);
            StreamReader := StreamReader.StreamReader(InStreamData, TRUE);
            AddInDataToFill.ADDTEXT(StreamReader.ReadToEnd());
        END;
    end;

    [Scope('Internal')]
    procedure SetCalendarPeriod(DateFromToSet: Date; DateToToSet: Date)
    begin
        DateFrom := DateFromToSet;
        DateTo := DateToToSet;
    end;

    [Scope('Internal')]
    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;

    [Scope('Internal')]
    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;
}

