codeunit 33019969 "Courier Track. - Post + Print"
{
    // This codeunit is called from Courier Tracking page for post and print functionality.

    TableNo = 33019987;

    trigger OnRun()
    begin
        GlobalCourierTrackHdr.COPY(Rec);
        CallPostingRoutine();
        Rec := GlobalCourierTrackHdr;
    end;

    var
        GlobalCourierTrackHdr: Record "33019987";
        Selection: Integer;
        Text33019961: Label '&Ship,&Receive';
        Text33019962: Label '&Return';
        GlobalPostShipment: Codeunit "33019966";
        GlobalPostReceipt: Codeunit "33019967";
        GlobalPostReturn: Codeunit "33019968";

    [Scope('Internal')]
    procedure CallPostingRoutine()
    begin
        //Taking the user selection and calling the appropriate codeunit.
        CASE GlobalCourierTrackHdr."Document Type" OF
            GlobalCourierTrackHdr."Document Type"::Transfer:
                BEGIN
                    Selection := STRMENU(Text33019961, 1);
                    IF Selection = 0 THEN
                        EXIT;
                    GlobalCourierTrackHdr.Ship := Selection IN [1];
                    GlobalCourierTrackHdr.Receive := Selection IN [2];
                END;
            GlobalCourierTrackHdr."Document Type"::Return:
                BEGIN
                    Selection := STRMENU(Text33019962, 1);
                    IF Selection = 0 THEN
                        EXIT;
                    GlobalCourierTrackHdr.Return := Selection IN [1];
                END;
        END;
        IF GlobalCourierTrackHdr.Ship THEN
            GlobalPostShipment.postAndPrint(GlobalCourierTrackHdr)
        ELSE
            IF GlobalCourierTrackHdr.Receive THEN
                GlobalPostReceipt.postAndPrint(GlobalCourierTrackHdr)
            ELSE
                IF GlobalCourierTrackHdr.Return THEN
                    GlobalPostReturn.RUN(GlobalCourierTrackHdr);
    end;
}

