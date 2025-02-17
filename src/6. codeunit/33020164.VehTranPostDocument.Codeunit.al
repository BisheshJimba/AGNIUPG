codeunit 33020164 "Veh. Tran. - Post Document"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure postInsMemo(PrmInsMemoHdr: Record "33020165")
    var
        LclInsMemoHdr: Record "33020165";
        LclVehTranChkDoc: Codeunit "33020163";
        Text33020166: Label 'Do you want to post?';
        Text33020167: Label 'Posted successfully!';
        Text33020168: Label 'Aborted by user - %1!';
        ConfirmPost: Boolean;
    begin
        //Confirmation dialog goes here.

        //Calling function of CODEUNIT::33020163 - checkInsMemo to check for empty fields on Hdr and Lines.
        LclVehTranChkDoc.checkInsMemo(PrmInsMemoHdr);

        //Calling function of CODEUNIT::33020163 - checkInsVehicle to check for vehicle information on Vehicle Insurance table.
        //LclVehTranChkDoc.checkInsVehicle(PrmInsMemoHdr);

        //Modifying record to posted.
        ConfirmPost := DIALOG.CONFIRM(Text33020166, TRUE);
        IF ConfirmPost THEN BEGIN
            LclInsMemoHdr.RESET;
            LclInsMemoHdr.SETRANGE("Vehicle Division", PrmInsMemoHdr."Vehicle Division");
            LclInsMemoHdr.SETRANGE("Reference No.", PrmInsMemoHdr."Reference No.");
            IF LclInsMemoHdr.FIND('-') THEN BEGIN
                LclInsMemoHdr.Posted := TRUE;
                LclInsMemoHdr.MODIFY;
                MESSAGE(Text33020167);
            END;
        END ELSE
            MESSAGE(Text33020168, USERID);
    end;

    [Scope('Internal')]
    procedure postCCMemo(PrmCCMemoHdr: Record "33020163")
    var
        LclCCMemoHdr: Record "33020163";
        LclVehTranChkDoc: Codeunit "33020163";
        Text33020163: Label 'Do you want to post?';
        Text33020164: Label 'Posted successfully!';
        ConfirmPost: Boolean;
        Text33020165: Label 'Aborted by user - %1!';
    begin
        //Calling function of CODEUNIT::33020163 - checkInsMemo to check for empty fields on Hdr and Lines.
        LclVehTranChkDoc.checkCCMemo(PrmCCMemoHdr);

        //Modifying record to posted.
        ConfirmPost := DIALOG.CONFIRM(Text33020163, TRUE);
        IF ConfirmPost THEN BEGIN
            LclCCMemoHdr.RESET;
            LclCCMemoHdr.SETRANGE("Vehicle Division", PrmCCMemoHdr."Vehicle Division");
            LclCCMemoHdr.SETRANGE("Reference No.", PrmCCMemoHdr."Reference No.");
            IF LclCCMemoHdr.FIND('-') THEN BEGIN
                LclCCMemoHdr.Posted := TRUE;
                LclCCMemoHdr.MODIFY;
                MESSAGE(Text33020164);
            END;
        END ELSE
            MESSAGE(Text33020165, USERID);
    end;
}

