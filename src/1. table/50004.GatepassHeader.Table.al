table 50004 "Gatepass Header"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Admin,Spare Parts Trade,Vehicle Trade,Vehicle Service,Vehicle GatePass';
            OptionMembers = " ",Admin,"Spare Parts Trade","Vehicle Trade","Vehicle Service","Vehicle GatePass";
        }
        field(2; "Document No"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                // IF "Document No" <> xRec."Document No" THEN BEGIN
                //     AdminSetup.GET;
                //     NoSeriesMngt.TestManual(GetNoSeries); //GetNoSeries internal scope issue
                //     "No. Series" := '';
                // END;
            end;
        }
        field(3; Location; Code[10])
        {
            Editable = false;
            TableRelation = Location.Code;
        }
        field(4; "Issued Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                // "Issued Date (BS)" := STPLSysMngt.getNepaliDate("Issued Date"); //getNepaliDate internal scope issue
            end;
        }
        field(5; "Issued Date (BS)"; Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                // "Issued Date" := STPLSysMngt.getEngDate("Issued Date (BS)"); //getNepaliDate internal scope issue
                // MODIFY;
            end;
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Person; Text[100])
        {
            Editable = false;
        }
        field(8; Destination; Text[100])
        {
        }
        field(9; Owner; Text[100])
        {
            Editable = false;
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Responsibility Center"; Code[10])
        {
            Editable = false;
        }
        field(12; "Issued By"; Code[50])
        {
            Editable = false;
        }
        field(13; "External Document No."; Code[20])
        {
            // TableRelation = IF ("Document Type" = CONST(Admin),
            //                     "External Document Type" = CONST("FA Transfer")) "FA Transfer"."No."
            // ELSE IF ("Document Type" = CONST(Admin),
            //                              "External Document Type" = CONST(Repair)) "Fixed Asset"."No."
            // ELSE IF ("Document Type" = CONST("Spare Parts Trade"),
            //                                       "External Document Type" = CONST("Transfer Order")) "Transfer Header"."No." WHERE("Document Profile" = CONST("Spare Parts Trade")) //document profile in transfer header
            // ELSE IF ("Document Type" = CONST("Spare Parts Trade"),
            //                                                "External Document Type" = CONST("Trail/Demo")) Contact."No."
            // ELSE IF ("Document Type" = CONST("Vehicle Service"),
            //                                                         "External Document Type" = CONST("Closed Job")) "Service Header EDMS"."No." WHERE("Service Person" = FILTER(<> ''))
            // ELSE IF ("Document Type" = CONST("Vehicle Service"),
            //                                                                  "External Document Type" = CONST("Vehicle Trial")) "Service Header Archive"."No."
            // ELSE IF ("Document Type" = CONST("Vehicle Trade"),
            //                                                                           "External Document Type" = CONST("Transfer Order")) "Transfer Header"."No." WHERE("Document Profile" = CONST("Vehicles Trade"))
            // ELSE IF ("Document Type" = CONST("Vehicle Service"),
            //                                                                                    "External Document Type" = CONST(Repair)) Item."No."
            // ELSE IF ("Document Type" = CONST("Vehicle GatePass"),
            //                                                                                             "External Document Type" = CONST("For Quotation")) "Service Header EDMS"."No.";

            trigger OnValidate()
            var
                ServiceHeaderEDMS: Record "Service Header EDMS";
            begin
                /*CASE "External Document Type" OF
                  "External Document Type"::Repair: BEGIN
                    SalesInvHeader.GET("External Document No.");
                    Owner := SalesInvHeader."Bill-to Name";
                    Person := SalesInvHeader."Sell-to Customer Name";
                    Destination := 'OUT';
                  END;
                
                  "External Document Type"::Invoice: BEGIN
                     ServiceHeader.RESET;
                     ServiceHeader.SETRANGE("No.","External Document No.");
                     IF ServiceHeader.FINDFIRST THEN BEGIN
                        Owner := '';
                        Person := '';
                        Destination := '';
                        "Vehicle Registration No." := '';
                
                        Owner := ServiceHeader."Bill-to Name";
                        Person := ServiceHeader."Sell-to Customer Name";
                        Destination := 'OUT';
                        "Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
                     END;
                  END;
                
                  "External Document Type"::"FA Transfer": BEGIN
                     ServArchiveHdr.RESET;
                     ServArchiveHdr.SETRANGE("No.","External Document No.");
                     IF ServArchiveHdr.FINDFIRST THEN BEGIN
                        Owner := '';
                        Person := '';
                        Destination := '';
                        "Vehicle Registration No." := '';
                
                        Owner := ServArchiveHdr."Bill-to Name";
                        Person := ServArchiveHdr."Sell-to Customer Name";
                        Destination := 'OUT';
                        "Vehicle Registration No." := ServArchiveHdr."Vehicle Registration No.";
                     END;
                  END;
                END;
                */

                /*Bishesh Jimba 26th Aug 2024*/
                "External Document Type" := "External Document Type"::"For Quotation";
                ServiceHeaderEDMS.RESET;
                ServiceHeaderEDMS.SETRANGE("No.", "External Document No.");
                IF ServiceHeaderEDMS.FINDFIRST THEN BEGIN
                    // "Vehicle Registration No." := ServiceHeaderEDMS."Vehicle Registration No."; //field exists need to solve error of table
                    // VIN := ServiceHeaderEDMS.VIN; //field exists need to solve error of table
                    // Owner := ServiceHeaderEDMS."Sell-to Customer Name"; //field exists need to solve error of table
                END;

            end;
        }
        field(14; Type; Option)
        {
            OptionCaption = 'Returnable,Non-Returnable';
            OptionMembers = Returnable,"Non-Returnable";
        }
        field(15; Printed; Boolean)
        {
            Editable = false;
        }
        field(16; Remarks; Text[250])
        {
        }
        field(17; "External Document Type"; Option)
        {
            OptionCaption = ' ,FA Transfer,Repair,Transfer Order,Invoice,Trail/Demo,Closed Job,Vehicle Trial,PDI,General CheckUp,For Quotation';
            OptionMembers = " ","FA Transfer",Repair,"Transfer Order",Invoice,"Trail/Demo","Closed Job","Vehicle Trial",PDI,"General CheckUp","For Quotation";
        }
        field(18; "No. of Print"; Integer)
        {
            Editable = false;
        }
        field(19; "Accountability Center"; Code[10])
        {
        }
        field(20; "Vehicle Registration No."; Code[20])
        {
            Editable = true;
            FieldClass = Normal;
            // TableRelation = Vehicle."Registration No."; //need to solve error in table
            // ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                //Bishesh Jimba 18Sep24
                "External Document Type" := "External Document Type"::"General CheckUp";
                Vehicle.RESET;
                // Vehicle.SETRANGE("Registration No.", Rec."Vehicle Registration No."); //need to solve error in table
                IF Vehicle.FINDFIRST THEN BEGIN
                    VIN := Vehicle.VIN;
                    VehicleContact.RESET;
                    VehicleContact.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
                    VehicleContact.SETFILTER("Relationship Code", '%1', 'OWNER');
                    IF VehicleContact.FINDFIRST THEN
                        VehicleContact.CALCFIELDS(VehicleContact."Contact Name");
                    Owner := VehicleContact."Contact Name";
                END;
            end;
        }
        field(21; "Ship Address"; Text[50])
        {
        }
        field(22; "Transfer From"; Text[50])
        {
        }
        field(23; "Transfer To"; Text[50])
        {
        }
        field(24; "Old Document Type"; Option)
        {
            OptionCaption = ' ,Vehicle Transfer,Vehicle Service,Spares,General Procurement,Battery,Lube,Material';
            OptionMembers = " ","Vehicle Transfer","Vehicle Service",Spares,"General Procurement",Battery,Lube,Material;
        }
        field(25; "Old Ext Document Type"; Option)
        {
            OptionCaption = ' ,Closed Job,Spare Parts Trade,Vehicle Trial';
            OptionMembers = " ","Closed Job","Spare Parts Trade","Vehicle Trial";
        }
        field(26; Kilometer; Decimal)
        {
        }
        field(50000; "Driver Name"; Text[30])
        {
        }
        field(50001; VIN; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No")
        {
            Clustered = true;
        }
        key(Key2; "External Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AdminSetup.GET;

        IF "Document No" = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "Document No", "No. Series");
        END;

        UserSetup.GET(USERID);
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        "Issued By" := USERID;
        Location := UserSetup."Default Location";
        VALIDATE("Issued Date", TODAY);
    end;

    trigger OnModify()
    var
        CannotChange: Label 'You cannot Change Printed Gatepass.';
    begin

        IF xRec.Printed THEN
            ERROR(CannotChange);
    end;

    var
        AdminSetup: Record "Admin. Management Setup";
        NoSeriesMngt: Codeunit 396;
        UserSetup: Record "User Setup";
        Calender: Record "Eng-Nep Date";
        STPLSysMngt: Codeunit 50000;
        SalesInvHeader: Record "Sales Invoice Header";
        ServiceHeader: Record "Service Header EDMS";
        ServArchiveHdr: Record "Service Header Archive";
        VehicleContact: Record "Vehicle Contact";
        Vehicle: Record Vehicle;

    [Scope('Internal')]
    procedure AssistEdit(xGatePass: Record "Gatepass Header"): Boolean
    begin
        AdminSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries, xGatePass."No. Series", "No. Series") THEN BEGIN
            AdminSetup.GET;
            TestNoSeries;
            NoSeriesMngt.SetSeries("Document No");
            EXIT(TRUE);
        END;
    end;

    // [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        CASE "Document Type" OF
            "Document Type"::Admin:
                AdminSetup.TESTFIELD("Gatepass Admin Trade No.");
            "Document Type"::"Vehicle Service":
                AdminSetup.TESTFIELD("Gatepass Vehicle Service No.");
            "Document Type"::"Vehicle Trade":
                AdminSetup.TESTFIELD("Gatepass Vehicle Trade No.");
            "Document Type"::"Spare Parts Trade":
                AdminSetup.TESTFIELD("Gatepass Spares No.");
            "Document Type"::"Vehicle GatePass"://Sambidh Rai 22aug24
                AdminSetup.TESTFIELD("Vehicle GatePass");
        END;
    end;

    // [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        CASE "Document Type" OF
            "Document Type"::Admin:
                EXIT(AdminSetup."Gatepass Admin Trade No.");
            "Document Type"::"Vehicle Service":
                EXIT(AdminSetup."Gatepass Vehicle Service No.");
            "Document Type"::"Vehicle Trade":
                EXIT(AdminSetup."Gatepass Vehicle Trade No.");
            "Document Type"::"Spare Parts Trade":
                EXIT(AdminSetup."Gatepass Spares No.");
            "Document Type"::"Vehicle GatePass"://Sambidh Rai 22aug24
                EXIT(AdminSetup."Vehicle GatePass");
        END;
    end;
}

