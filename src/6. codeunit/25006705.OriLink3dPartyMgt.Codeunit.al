codeunit 25006705 "OriLink 3d Party Mgt."
{
    SingleInstance = true;
    TableNo = 25006705;

    trigger OnRun()
    begin
        /*//17.02.2015 Elva Baltic P1 - temp commented
        
        SIENo := Rec."SIE No.";
        IF "Run Mode" = "Run Mode"::Post THEN BEGIN
          AutoPostJnl("Posting Unit");
          IF "Asignment Unit" > 0 THEN
            AutoAsign("Asignment Unit");
          EXIT
        END;
        
        IF ISCLEAR(CC2) THEN
          CREATE(CC2, FALSE, TRUE);
        
        IF ISCLEAR(SBA) THEN
          CREATE(SBA, FALSE, TRUE);
        
        //IF ISCLEAR(XMLDom) THEN
        //  CREATE(XMLDom);
        
        CC2.AddBusAdapter(SBA, 0);
        
        IF NOT SocketOpened THEN BEGIN
         SBA.OpenSocket(8077, ' ');
         SocketOpened := TRUE;
        END;
        
        */

    end;

    var
        SocketOpened: Boolean;
        Text010: ;
        XMLElement: Automation;
        XMLNode: Automation;
        XMLNodeList: Automation;
        RequestType: Option Unknown,JobNo,FWT;
        txt: Text[30];
        Text011: ;
        Text020: Label 'Error in parsing Job No.';
        SIENo: Code[10];
        Text030: Label 'Is going to AutoPostJnl via C %1 with SIEJnl filtered by %2, first record No: %3.';

    [Scope('Internal')]
    procedure GetRequestType(): Integer
    begin
    end;

    [Scope('Internal')]
    procedure ProcessJobValidation(var OutS: OutStream)
    var
        JobNo: Code[20];
        ResponseNo: Integer;
        ResponseText: Text[1000];
        TestFile: File;
        ServHeader: Record "25006145";
        CustName: Text[30];
    begin
    end;

    [Scope('Internal')]
    procedure ProcessFWT(var OutS: OutStream)
    var
        ResponseText: Text[1000];
        TestFile: File;
    begin

        FillSIEJnl;

        //Creating Response Text
        ResponseText := '<?xml version="1.0" encoding="ISO-8859-1"?> ';
        ResponseText += '<Oil_Issue>';
        ResponseText += '<Result>0</Result>';
        ResponseText += '<Description>Accepted</Description>';
        ResponseText += '</Oil_Issue>';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        OutS.WRITETEXT(ResponseText);
    end;

    [Scope('Internal')]
    procedure FillSIEJnl()
    var
        SIEJnlLine: Record "25006702";
        LineNo: Integer;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        HoursText: Text[2];
        MinutesText: Text[2];
        SecondsText: Text[2];
        NewTime: Time;
    begin
    end;

    [Scope('Internal')]
    procedure AutoPostJnl(PostingUnit: Integer)
    var
        JnlLine: Record "25006702";
        SAMOAJnlPost: Codeunit "25006704";
    begin
        CLEAR(JnlLine);
        JnlLine.SETRANGE("SIE No.", SIENo);
        IF NOT JnlLine.FINDFIRST THEN EXIT;
        IF NOT GUIALLOWED THEN
            MESSAGE(Text030, PostingUnit, SIENo, JnlLine."Line No.");
        CODEUNIT.RUN(PostingUnit, JnlLine);
    end;

    [Scope('Internal')]
    procedure AutoAsign(AutoAsignUnit: Integer)
    var
        JnlLine: Record "25006702";
        SAMOAJnlPost: Codeunit "25006704";
    begin
        CODEUNIT.RUN(AutoAsignUnit);
    end;

    [Scope('Internal')]
    procedure JobNoIsValid(JobNo: Code[20]): Boolean
    var
        ServHeader: Record "25006145";
        ServOrdInfoPaneMgt: Codeunit "25006104";
    begin
        ServHeader.RESET;
        IF NOT ServHeader.GET(ServHeader."Document Type"::Order, JobNo) THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;
}

