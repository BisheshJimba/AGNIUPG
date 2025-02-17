codeunit 25006009 "Vehicle Change Log Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        recVehChangeLog: Record "25006029";
        recVehChangeLog2: Record "25006029";

    [Scope('Internal')]
    procedure fRegisterChange(var recVehicle: Record "25006005"; var xrecVehicle: Record "25006005"; intFieldNo: Integer)
    begin
        CASE intFieldNo OF
            recVehicle.FIELDNO("Status Code"):
                BEGIN
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FIELDNO("Status Code");
                    recVehChangeLog."Field Description" := recVehicle.FIELDCAPTION("Status Code");
                    recVehChangeLog."Old Value" := xrecVehicle."Status Code";
                    recVehChangeLog."New Value" := recVehicle."Status Code";
                    fInsertEntry(recVehicle);
                END;
            recVehicle.FIELDNO("Tracking Code"):
                BEGIN
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FIELDNO("Tracking Code");
                    recVehChangeLog."Field Description" := recVehicle.FIELDCAPTION("Tracking Code");
                    recVehChangeLog."Old Value" := xrecVehicle."Tracking Code";
                    recVehChangeLog."New Value" := recVehicle."Tracking Code";
                    fInsertEntry(recVehicle);
                END;
            recVehicle.FIELDNO(VIN):
                BEGIN
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FIELDNO(VIN);
                    recVehChangeLog."Field Description" := recVehicle.FIELDCAPTION(VIN);
                    recVehChangeLog."Old Value" := xrecVehicle.VIN;
                    recVehChangeLog."New Value" := recVehicle.VIN;
                    fInsertEntry(recVehicle);
                END;
            recVehicle.FIELDNO("Registration No."):
                BEGIN
                    fInitEntry(recVehicle);
                    recVehChangeLog."Field No." := recVehicle.FIELDNO("Registration No.");
                    recVehChangeLog."Field Description" := recVehicle.FIELDCAPTION("Registration No.");
                    recVehChangeLog."Old Value" := xrecVehicle."Registration No.";
                    recVehChangeLog."New Value" := recVehicle."Registration No.";
                    fInsertEntry(recVehicle);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure fInitEntry(var recVehicle: Record "25006005")
    begin
        recVehChangeLog.INIT;
        recVehChangeLog."Vehicle Serial No." := recVehicle."Serial No.";
        recVehChangeLog."User ID" := USERID;
        recVehChangeLog."Date of Change" := WORKDATE;
        recVehChangeLog."Time of Change" := TIME;
    end;

    [Scope('Internal')]
    procedure fInsertEntry(var recVehicle: Record "25006005")
    begin
        recVehChangeLog."Change No." := fGetLastChangeNo(recVehicle) + 1;

        recVehChangeLog."Type of Change" := recVehChangeLog."Type of Change"::Modify;
        IF recVehChangeLog."Old Value" = '' THEN
            recVehChangeLog."Type of Change" := recVehChangeLog."Type of Change"::Insert;
        IF recVehChangeLog."New Value" = '' THEN
            recVehChangeLog."Type of Change" := recVehChangeLog."Type of Change"::Delete;

        recVehChangeLog.INSERT;
    end;

    [Scope('Internal')]
    procedure fGetLastChangeNo(var recVehicle: Record "25006005"): Integer
    begin
        recVehChangeLog2.RESET;
        recVehChangeLog2.SETRANGE("Vehicle Serial No.", recVehicle."Serial No.");
        IF recVehChangeLog2.FINDLAST THEN
            EXIT(recVehChangeLog2."Change No.")
        ELSE
            EXIT(0)
    end;
}

