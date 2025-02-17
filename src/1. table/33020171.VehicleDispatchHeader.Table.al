table 33020171 "Vehicle Dispatch Header"
{
    Permissions = TableData 112 = rm,
                  TableData 25006005 = rm;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Transfer-from Code"; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                TestFieldDispatched;
                IF ("Transfer-from Code" = "Transfer-to Code") AND
                   ("Transfer-from Code" <> '')
                THEN
                    ERROR(
                      Text001,
                      FIELDCAPTION("Transfer-from Code"), FIELDCAPTION("Transfer-to Code"),
                      TABLECAPTION, "No.");
            end;
        }
        field(3; "Transfer-to Code"; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                TestFieldDispatched;
                IF ("Transfer-from Code" = "Transfer-to Code") AND
                   ("Transfer-to Code" <> '')
                THEN
                    ERROR(
                      Text001,
                      FIELDCAPTION("Transfer-from Code"), FIELDCAPTION("Transfer-to Code"),
                      TABLECAPTION, "No.");
            end;
        }
        field(4; Remarks; Text[100])
        {
        }
        field(5; "Dispatched By"; Code[50])
        {
            Editable = false;
        }
        field(6; Dispatched; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Dispatched By" := USERID;
                "Dispatched Date" := TODAY;
                "Dispatched Time" := TIME;
            end;
        }
        field(7; Received; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Received By" := USERID;
                "Received Date" := TODAY;
                "Received Time" := TIME;
            end;
        }
        field(8; "Dispatched Date"; Date)
        {
        }
        field(9; "Received Date"; Date)
        {
        }
        field(50000; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50001; "Received By"; Code[50])
        {
        }
        field(50002; "Dispatched Time"; Time)
        {
        }
        field(50003; "Received Time"; Time)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Dispatched, FALSE);
        TESTFIELD(Received, FALSE);
    end;

    trigger OnInsert()
    begin
        SalesSetup.GET;
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD(Dispatched, FALSE);
        TESTFIELD(Received, FALSE);
    end;

    var
        NoSeriesMngt: Codeunit "396";
        SalesSetup: Record "311";
        Text001: Label '%1 and %2 cannot be the same in %3 %4.';
        Text000: Label 'Nothing to Post.';
        Text002: Label 'Document posted successfully.';
        UserSetup: Record "91";
        NoShip: Label 'You are not authorised to dispatch from %1.';
        NoReceive: Label 'You are not authorised to receive from %1.';

    [Scope('Internal')]
    procedure AssistEdit(xVehDispatch: Record "33020171"): Boolean
    begin
        SalesSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries, xVehDispatch."No. Series", "No. Series") THEN BEGIN
            SalesSetup.GET;
            TestNoSeries;
            NoSeriesMngt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        SalesSetup.TESTFIELD(SalesSetup."Veh. Dispatch No.");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(SalesSetup."Veh. Dispatch No.");
    end;

    [Scope('Internal')]
    procedure TestFieldDispatched()
    begin
    end;

    [Scope('Internal')]
    procedure DispatchVehicle(var VehDispatchRec: Record "33020171"): Boolean
    var
        VehDispatchLine: Record "33020172";
        Vehicle: Record "25006005";
        SalesInvHeader: Record "112";
        DefaultNumber: Option Dispatch,Receive;
        Selection: Option Dispatch,Receive;
        UserOption: Label '&Dispatch,&Receive';
        Title: Label 'Choose the following option.';
    begin
        IF VehDispatchRec.Dispatched THEN
            DefaultNumber := 2
        ELSE
            DefaultNumber := 1;
        Selection := STRMENU(UserOption, DefaultNumber, Title);
        CASE Selection OF
            1:
                BEGIN
                    UserSetup.GET(USERID);
                    IF UserSetup."Default Location" <> VehDispatchRec."Transfer-from Code" THEN
                        ERROR(NoShip, VehDispatchRec."Transfer-from Code");
                    VehDispatchRec.TESTFIELD("Transfer-from Code");
                    VehDispatchRec.TESTFIELD("Transfer-to Code");
                    VehDispatchRec.TESTFIELD(Dispatched, FALSE);
                    VehDispatchLine.RESET;
                    VehDispatchLine.SETRANGE("Document No", VehDispatchRec."No.");
                    IF VehDispatchLine.FINDSET THEN
                        REPEAT
                            SalesInvHeader.RESET;
                            SalesInvHeader.GET(VehDispatchLine."Sales Invoice No.");
                            SalesInvHeader.Dispatched := TRUE;
                            SalesInvHeader.MODIFY;
                            Vehicle.RESET;
                            Vehicle.GET(VehDispatchLine."Vehicle Serial No.");
                            Vehicle."Location After Sale" := 'IN-TRANSIT';
                            Vehicle.MODIFY;
                        UNTIL VehDispatchLine.NEXT = 0
                    ELSE
                        ERROR(Text000);
                    VehDispatchRec.VALIDATE(Dispatched, TRUE);
                    VehDispatchRec.MODIFY;
                    EXIT(TRUE);
                END;
            2:
                BEGIN

                    VehDispatchRec.TESTFIELD("Transfer-from Code");
                    VehDispatchRec.TESTFIELD("Transfer-to Code");
                    VehDispatchRec.TESTFIELD(Dispatched, TRUE);
                    VehDispatchRec.TESTFIELD(Received, FALSE);
                    UserSetup.GET(USERID);
                    IF UserSetup."Default Location" <> VehDispatchRec."Transfer-to Code" THEN
                        ERROR(NoReceive, VehDispatchRec."Transfer-to Code");
                    VehDispatchLine.RESET;
                    VehDispatchLine.SETRANGE("Document No", VehDispatchRec."No.");
                    IF VehDispatchLine.FINDSET THEN
                        REPEAT
                            Vehicle.RESET;
                            Vehicle.GET(VehDispatchLine."Vehicle Serial No.");
                            Vehicle."Location After Sale" := VehDispatchRec."Transfer-to Code";
                            Vehicle.MODIFY;
                        UNTIL VehDispatchLine.NEXT = 0
                    ELSE
                        ERROR(Text000);
                    VehDispatchRec.VALIDATE(Received, TRUE);
                    VehDispatchRec.MODIFY;
                    MESSAGE(Text002);
                END;
        END;
    end;
}

