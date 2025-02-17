table 33019894 "Posted Battery Job Header"
{

    fields
    {
        field(1; "Job Card No."; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                 IF "Job Card No." <> xRec."Job Card No." THEN
                 BEGIN
                  SerMgtSetup.GET;
                  NoSeriesMgmt.TestManual(SerMgtSetup."Job Card No.");
                  "No. Series" := '';
                 END;
                  */

            end;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Contact.No.;

            trigger OnValidate()
            begin
                /*
               IF "Customer No." <> '' THEN
                BEGIN
                 CustomerVar.GET("Customer No.");
                 "Customer Name" := CustomerVar.Name + ' ' + ',' + ' ' + CustomerVar.Address;
                END;

               IF "Customer No." <> '' THEN BEGIN
                  CustomerVar.GET("Customer No.");
                  "Customer Name" := CustomerVar.Name;
                  "Customer Address" :=  CustomerVar.Address;
                END;
                */

                IF "Customer No." <> '' THEN BEGIN
                    Contact.GET("Customer No.");
                    "Customer Name" := Contact.Name;
                    "Customer Address" := Contact.Address;
                END;
                //SETRANGE("Customer Type","Customer Type"::BTD);

            end;
        }
        field(3; "Customer Name"; Text[50])
        {
            Description = 'Includes customer name';
        }
        field(4; "Sales Date"; Date)
        {

            trigger OnValidate()
            begin
                "Battery Life" := '';
                IF "Job Start Date" <> 0DT THEN BEGIN
                    JobStartDate := DT2DATE("Job Start Date");
                    //MESSAGE('%1',JobStartDate);
                END;

                IF "Sales Date" <> 0D THEN BEGIN

                    Months := ROUND((JobStartDate - "Sales Date") / 30.41, 0.01);
                    IF (DATE2DMY(JobStartDate, 3) - DATE2DMY("Sales Date", 3)) >= 1 THEN
                        "Battery Life" := FORMAT(DATE2DMY(JobStartDate, 3) - DATE2DMY("Sales Date", 3)) + ' Years ';
                    IF (DATE2DMY(JobStartDate, 2) - DATE2DMY("Sales Date", 2)) > 0 THEN
                        "Battery Life" += FORMAT(DATE2DMY(JobStartDate, 2) - DATE2DMY("Sales Date", 2)) + ' Months ';
                    IF (DATE2DMY(JobStartDate, 1) - DATE2DMY("Sales Date", 1)) > 0 THEN
                        "Battery Life" += FORMAT(DATE2DMY(JobStartDate, 1) - DATE2DMY("Sales Date", 1)) + ' Days ';
                    Month := Months;

                    //MESSAGE('%1',Months);
                    "Sales Date (BS)" := SysMngt.getNepaliDate("Sales Date");

                END
                ELSE BEGIN
                    "Sales Date (BS)" := '';
                    Month := 0.0;
                END;
            end;
        }
        field(5; "Warranty Date"; DateTime)
        {

            trigger OnValidate()
            begin
                IF "Warranty Date" <> 0DT THEN BEGIN
                    "Job Start Date" := "Warranty Date";
                END;
            end;
        }
        field(6; Month; Decimal)
        {
        }
        field(7; "Job Start Date"; DateTime)
        {
        }
        field(8; "Promise Date"; DateTime)
        {
        }
        field(9; "Job End Date"; DateTime)
        {
        }
        field(10; "Customer Agent No."; Code[20])
        {
            TableRelation = Customer.No. WHERE(Is Dealer=CONST(Yes));

            trigger OnValidate()
            begin
                IF "Customer Agent No." <> '' THEN BEGIN
                    CustomerVar.GET("Customer Agent No.");
                    // "Customer Agent Name" := CustomerVar.Name + ' ' + ',' + ' ' + CustomerVar.Address;
                    "Customer Agent Name" := CustomerVar.Name;
                    "Dealer Address" := CustomerVar.Address;
                END
                ELSE BEGIN
                    "Customer Agent Name" := '';
                    "Dealer Address" := '';

                END;
            end;
        }
        field(11; "Customer Agent Name"; Text[50])
        {
            Description = 'Includes customer agent name';
        }
        field(12; "Battery Part No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Item Category Code=CONST(BATTERY));

            trigger OnLookup()
            begin
                //BatteryList.RUN;
                Item.RESET;
                IF LookUpMgt.LookUpBatteryItems(Item, "Battery Part No.") THEN
                    VALIDATE("Battery Part No.", Item."No.");
            end;

            trigger OnValidate()
            begin
                IF "Battery Part No." <> '' THEN BEGIN
                    BATPartNumVar.GET("Battery Part No.");
                    "Battery Description" := BATPartNumVar.Description;
                    "Battery Type" := BATPartNumVar."Product Subgroup Code";
                END;
            end;
        }
        field(13; "Battery Description"; Text[30])
        {
        }
        field(14; "Battery Type"; Text[30])
        {
        }
        field(15; MFG; Text[10])
        {
        }
        field(16; "Vehicle Model"; Text[30])
        {
        }
        field(17; "Vehicle Type"; Option)
        {
            OptionCaption = ' ,BUS,CAR,TRACTOR,MOTORCYCLE,GENERATOR,UPS,INVERTER,JEEP,TAXI,PICKUP,TRUCK,EARTH EQUIP,UNSOLD,INDUSTRIAL,COMMERCIAL VEHICLES,OTHERS';
            OptionMembers = " ",BUS,CAR,TRACTOR,MOTORCYCLE,GENERATOR,UPS,INVERTER,JEEP,TAXI,PICKUP,TRUCK,"EARTH EQUIP",UNSOLD,INDUSTRIAL,"COMMERCIAL VEHICLES",OTHERS;

            trigger OnValidate()
            begin
                CalculateWarranty;
            end;
        }
        field(18; Registration; Text[30])
        {
        }
        field(19; "OE/Trd"; Option)
        {
            OptionMembers = TR,OE,PW,MO,MT,MW;
        }
        field(20; "KM."; Text[30])
        {
        }
        field(21; "Serv Batt Type"; Text[30])
        {
        }
        field(22; "Gua.Card"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(23; "Replaced Part"; Code[20])
        {
            TableRelation = Item.No. WHERE(Item For=CONST(BTD),
                                            IsScrap=CONST(No));

            trigger OnLookup()
            begin
                Item.RESET;
                IF LookUpMgt.LookUpBatteryItems(Item, "Replaced Part") THEN
                    VALIDATE("Replaced Part", Item."No.");
            end;
        }
        field(24; "Rep. Batt. Serial"; Code[20])
        {
        }
        field(25; Remarks; Text[250])
        {

            trigger OnValidate()
            begin
                Remarks := UPPERCASE(Remarks);
            end;
        }
        field(26; "Internal Comment"; Text[250])
        {
        }
        field(27; "Job For"; Code[10])
        {
        }
        field(28; "Transfer Ref."; Code[20])
        {
        }
        field(29; "Claim No."; Code[20])
        {
        }
        field(30; "Issue No."; Code[20])
        {
        }
        field(31; Bill; Code[20])
        {
        }
        field(32; GRN; Code[20])
        {
        }
        field(33; "Job Closed"; Boolean)
        {
        }
        field(34; Date; Date)
        {
        }
        field(35; "Bill to Agent"; Boolean)
        {
        }
        field(36; Recharged; Boolean)
        {
        }
        field(37; "Cut Piece Received"; Boolean)
        {
        }
        field(38; "Created By"; Text[50])
        {
        }
        field(39; "Updated By"; Text[50])
        {
        }
        field(40; "No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(41; "Battery Serial No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Battery Serial No." <> '' THEN BEGIN
                    JobCardNo := '';
                    BATSERJCTable.RESET;
                    BATSERJCTable.SETCURRENTKEY("Battery Serial No.");
                    BATSERJCTable.SETRANGE("Battery Serial No.", "Battery Serial No.");
                    IF BATSERJCTable.FINDSET THEN BEGIN
                        REPEAT
                            IF JobCardNo <> '' THEN
                                JobCardNo += ', ' + BATSERJCTable."Job Card No."
                            ELSE
                                JobCardNo := BATSERJCTable."Job Card No.";
                        UNTIL BATSERJCTable.NEXT = 0;
                        MESSAGE(Text000, JobCardNo);
                    END;
                END;
            end;
        }
        field(42; "Rep. Batt. MFG"; Text[10])
        {
        }
        field(43; "Exide Claim"; Boolean)
        {
        }
        field(44; "Warranty Percentage"; Decimal)
        {
        }
        field(45; "Service Batt No."; Code[20])
        {
        }
        field(46; "Action"; Option)
        {
            OptionMembers = " ",Recharge,Replace,Reject,Others,Pending;

            trigger OnValidate()
            begin
                TESTFIELD("Job End Date");
            end;
        }
        field(47; "Prorata Percent"; Text[20])
        {
        }
        field(48; TEst; Integer)
        {
        }
        field(49; "Sales Date (BS)"; Code[10])
        {

            trigger OnValidate()
            begin
                IF "Job Start Date" <> 0DT THEN BEGIN
                    JobStartDate := DT2DATE("Job Start Date");
                    //MESSAGE('%1',Date);
                END;


                IF "Sales Date (BS)" <> '' THEN BEGIN
                    "Sales Date" := SysMngt.getEngDate("Sales Date (BS)");
                    MODIFY;

                    Months := ROUND((JobStartDate - "Sales Date") / 30.41, 0.01);
                    Month := Months;

                END
                ELSE BEGIN
                    "Sales Date" := 0D;
                    Month := 0.0;
                END;
            end;
        }
        field(50; "Customer Address"; Text[100])
        {
        }
        field(51; "Dealer Address"; Text[100])
        {
        }
        field(52; "Responsibility Center"; Code[20])
        {
        }
        field(53; "Location Code"; Code[20])
        {
        }
        field(54; Dimension1; Code[20])
        {
        }
        field(55; Dimension2; Code[20])
        {
        }
        field(56; "User ID"; Code[50])
        {
        }
        field(57; "Battery Life"; Text[50])
        {
            Description = 'Added since Month field is not working';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50000; CustomerPhone; Text[50])
        {
        }
        field(50001; "Sales Invoice No."; Code[20])
        {
        }
        field(50002; TotalClaimAmount; Decimal)
        {
            CalcFormula = Lookup("Exide Claim"."Total Claim Amount" WHERE(Job Card No.=FIELD(Job Card No.)));
                FieldClass = FlowField;
        }
        field(50003; Apply; Boolean)
        {
        }
        field(50004; Applied; Boolean)
        {
        }
        field(50005; "InvoiceNo."; Code[20])
        {
        }
        field(50006; "Manufacture Company Name"; Text[50])
        {
        }
        field(50007; "Manual Job Card No."; Code[20])
        {
        }
        field(50008; "Manual Job Card Date"; Date)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Job Card No.")
        {
            Clustered = true;
        }
        key(Key2; "Battery Serial No.")
        {
        }
        key(Key3; "Job End Date")
        {
        }
        key(Key4; "Claim No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        IF "Job Card No." = '' THEN
         BEGIN
          SerMgtSetup.GET;
          SerMgtSetup.TESTFIELD(SerMgtSetup."Job Card No.");
          NoSeriesMgmt.InitSeries(SerMgtSetup."Job Card No.",xRec."No. Series",0D,"Job Card No.","No. Series");
         END;

       "Created By" := USERID;
       UserSetup.GET(USERID);
       "Job For" := UserSetup."Default Location";
       "Warranty Date" := CURRENTDATETIME;
       "Job Start Date" := CURRENTDATETIME;

      // To enter cell value from cell template to job card lines
        JobCardLine.INIT;
        REPEAT
        JobCardLine."Job Card No." := "Job Card No.";
        JobCardLine.Cell := CellTemplate.Cell;
        IF CellTemplate.Cell <> 0 THEN
           JobCardLine.INSERT;
        UNTIL CellTemplate.NEXT = 0;
        */

    end;

    trigger OnModify()
    begin
        /*
        IF (("OE/Trd" = "OE/Trd"::PW) OR ("OE/Trd" = "OE/Trd"::MW)) THEN BEGIN
             IF "Prorata Percent" = '' THEN
             TESTFIELD("Prorata Percent");
        END;
        */

    end;

    var
        SerMgtSetup: Record "5911";
        BATSERJCTable: Record "33019884";
        NoSeriesMgmt: Codeunit "396";
        CustomerVar: Record "18";
        BATPartNumVar: Record "27";
        Months: Decimal;
        GblBatteryWarranty: Record "33019887";
        UserSetup: Record "91";
        JobCardNo: Code[1024];
        Text000: Label 'This Battery Serial No. is Already Used in Job Cards %1.';
        JobCardLine: Record "33019885";
        BatteryList: Page "33019913";
        LookUpMgt: Codeunit "25006003";
        Item: Record "27";
        CellTemplate: Record "33019893";
        SysMngt: Codeunit "50000";
        Contact: Record "5050";
        JobStartDate: Date;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        /* WITH BATSERJCTable DO
          BEGIN
           BATSERJCTable := Rec;
           SerMgtSetup.GET;
           SerMgtSetup.TESTFIELD(SerMgtSetup."Job Card No.");
            IF NoSeriesMgmt.SelectSeries(SerMgtSetup."Job Card No.",xRec."No. Series","No. Series") THEN
             BEGIN
              SerMgtSetup.GET;
              SerMgtSetup.TESTFIELD(SerMgtSetup."Job Card No.");
              NoSeriesMgmt.SetSeries("Job Card No.");
              Rec := BATSERJCTable;
              EXIT(TRUE);
             END;
          END;
         */

    end;

    [Scope('Internal')]
    procedure CalculateWarranty()
    begin
        GblBatteryWarranty.SETRANGE("Vehicle Type", "Vehicle Type");
        GblBatteryWarranty.SETRANGE("Battery Type", "Battery Type");
        IF GblBatteryWarranty.FIND('-') THEN BEGIN
            REPEAT
                IF (Month >= GblBatteryWarranty."Month From") AND (Month <= GblBatteryWarranty."Month To") THEN BEGIN
                    "Warranty Percentage" := GblBatteryWarranty.Warranty;

                END;
            UNTIL GblBatteryWarranty.NEXT <= 0;
        END
        ELSE BEGIN
            "Warranty Percentage" := 0;
        END;
    end;
}

