table 33019886 "Exide Claim"
{

    fields
    {
        field(1; "Claim No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Claim No." <> xRec."Claim No." THEN BEGIN
                    SerMgtSetup.GET;
                    NoSeriesMgmt.TestManual(SerMgtSetup."Claim No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Claim Date"; Date)
        {
        }
        field(3; "Job Card No."; Code[20])
        {
            TableRelation = "Posted Battery Job Header"."Job Card No.";

            trigger OnValidate()
            begin
                IF "Job Card No." <> '' THEN BEGIN
                    PostedJobHeader.GET("Job Card No.");
                    "Battery Part No." := PostedJobHeader."Battery Part No.";
                    "Battery Description" := PostedJobHeader."Battery Description";
                    "Vehicle Type" := PostedJobHeader."Vehicle Type";
                    "No. of Months" := PostedJobHeader.Month;
                    "Job Date" := PostedJobHeader."Job Start Date";
                    "Claim Date" := TODAY;
                    "Issue Part No." := PostedJobHeader."Battery Part No.";


                    "Qty." := 1;

                    // to set pro-rata %
                    IF (PostedJobHeader."Warranty Percentage" > 0) AND (PostedJobHeader."Warranty Percentage" < 100) THEN
                        "Pro-Rata %" := PostedJobHeader."Warranty Percentage"
                    ELSE
                        "Pro-Rata %" := 100;



                    //to get scrap no and amount
                    Item.SETRANGE("No.", PostedJobHeader."Battery Part No.");
                    IF Item.FINDFIRST THEN
                        ScrapNo := Item."Scrap No.";
                    "Scrap No." := ScrapNo;

                    /*
                    SalesPrice.SETRANGE("Item No.",ScrapNo);
                    IF SalesPrice.FINDFIRST THEN
                       ScrapAmount := SalesPrice."Unit Price";
                       "Scrap Amount" := ScrapAmount;
                    */
                    Item.SETRANGE("No.", ScrapNo);
                    IF Item.FINDFIRST THEN
                        ScrapAmount := Item."Scrap Amount";

                    "Scrap Amount" := ScrapAmount;

                    GblExideClaimFactor.FINDFIRST;
                    // to get NDP Rate and other amount
                    GblBattInfo.SETRANGE(GblBattInfo."No.", "Battery Part No.");
                    IF GblBattInfo.FINDFIRST THEN
                        "NDP Rate" := GblBattInfo."NDP Rate";
                    //sm to calcualte claim amount with respect to warranty percentage   9/20/2012
                    IF "Pro-Rata %" = 100 THEN BEGIN
                        "Claim Amount" := "NDP Rate";
                    END ELSE BEGIN
                        // "Claim %" := 100 - "Pro-Rata %";
                        "Claim %" := "Pro-Rata %";
                        "Claim Amount" := ROUND(("NDP Rate" * "Claim %") / 100, 0.01);
                    END;


                    // "Additional Amount" := ROUND(("Claim Amount" * 31.73 ) / 100,0.01);
                    "Additional Amount" := ROUND(("Claim Amount" * GblExideClaimFactor.Percentage) / 100, 0.01);

                    "Total Claim Amount" := "Claim Amount" + "Additional Amount" - "Scrap Amount" / 1.6015; //12.5.2012 Sipradi-YS


                    // code to get info if selected job card no is present
                    ExideClaimTable.SETRANGE(ExideClaimTable."Job Card No.", "Job Card No.");
                    IF ExideClaimTable.FINDFIRST THEN
                        "Issue Part No." := ExideClaimTable."Issue Part No.";
                    "Issue Part Description" := ExideClaimTable."Issue Part Description";
                    "Issue Qty." := ExideClaimTable."Issue Qty.";
                    "Sales Rate" := ExideClaimTable."Sales Rate";
                    Total := ExideClaimTable.Total;
                    "Claim No." := ExideClaimTable."Claim No.";
                    // "Claim Date" := ExideClaimTable."Claim Date";
                    "Issue No." := ExideClaimTable."Issue No.";
                END;

            end;
        }
        field(4; "Job Date"; DateTime)
        {
        }
        field(5; "No. of Months"; Decimal)
        {
        }
        field(6; "Issue No."; Code[20])
        {

            trigger OnValidate()
            begin

                IF "Issue No." <> xRec."Issue No." THEN BEGIN
                    SerMgtSetup.GET;
                    NoSeriesMgmt.TestManual(SerMgtSetup."Issue No.");
                    "No. Series1" := '';
                END
            end;
        }
        field(7; "Battery Part No."; Code[20])
        {
        }
        field(8; "Battery Description"; Text[30])
        {
        }
        field(9; "Vehicle Type"; Option)
        {
            OptionMembers = " ",BUS,CAR,TRACTOR,MOTORCYCLE,GENERATOR,UPS,INVERTER,JEEP,TAXI,PICKUP,TRUCK,"EARTH EQUIP",UNSOLD,INDUSTRIAL,"COMMERCIAL VEHICLES",OTHERS;
        }
        field(10; "Qty."; Integer)
        {
        }
        field(11; "NDP Rate"; Decimal)
        {
        }
        field(12; "Claim Amount"; Decimal)
        {
        }
        field(13; "Additional Amount"; Decimal)
        {
        }
        field(14; "Total Claim Amount"; Decimal)
        {
        }
        field(15; "Issue Part No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Item For=CONST(BTD),
                                            IsScrap=CONST(No));

            trigger OnLookup()
            begin
                Item.RESET;
                IF LookUpMgt.LookUpBatteryItems(Item, "Issue Part No.") THEN
                    VALIDATE("Issue Part No.", Item."No.");
            end;

            trigger OnValidate()
            begin
                IF "Issue Part No." <> '' THEN BEGIN
                    GblBattInfo.GET("Issue Part No.");
                    "Issue Part Description" := GblBattInfo.Description;
                    "Issue Qty." := 1;
                    // BATPartNumVar.GET("Battery Part No.");
                    //"Battery Description" := BATPartNumVar.Description;
                    // "Battery Type" := BATPartNumVar."Product Subgroup Code";
                    GblSalesPrice.SETRANGE(GblSalesPrice."Item No.", "Issue Part No.");
                    IF GblSalesPrice.FINDFIRST THEN
                        "Sales Rate" := GblSalesPrice."Unit Price";

                    Total := "Sales Rate" * "Issue Qty.";
                END;


                /*
                 IF "Issue No." = '' THEN
                  BEGIN
                   SerMgtSetup.GET;
                   SerMgtSetup.TESTFIELD(SerMgtSetup."Issue No.");
                   NoSeriesMgmt.InitSeries(SerMgtSetup."Issue No.",xRec."No. Series1",0D,"Issue No.","No. Series1");
                 END;
                */

            end;
        }
        field(16; "Issue Part Description"; Text[30])
        {
        }
        field(17; "Issue Qty."; Integer)
        {

            trigger OnValidate()
            begin
                Total := "Issue Qty." * "Sales Rate";
            end;
        }
        field(18; "Sales Rate"; Decimal)
        {
        }
        field(19; Total; Decimal)
        {
        }
        field(20; "Pro-Rata %"; Decimal)
        {
        }
        field(21; "Exide Claim Date"; Date)
        {
        }
        field(22; "Exide Credit Date"; Date)
        {
        }
        field(23; "Credit Amount"; Decimal)
        {
        }
        field(24; Remarks; Text[50])
        {
        }
        field(25; "No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(26; "No. Series1"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(27; Issued; Boolean)
        {
        }
        field(28; "Claim Status"; Option)
        {
            OptionMembers = " ",Accept,Reject;
        }
        field(29; "Responsibility Center"; Code[20])
        {
        }
        field(30; "Location Code"; Code[20])
        {
        }
        field(31; "Dimension 1"; Code[20])
        {
        }
        field(32; "Dimension 2"; Code[20])
        {
        }
        field(33; "User ID"; Code[50])
        {
        }
        field(34; "Scrap No."; Code[20])
        {
        }
        field(35; "Scrap Amount"; Decimal)
        {
        }
        field(36; "Sales Order Posted"; Boolean)
        {
            CalcFormula = Exist("Sales Invoice Header" WHERE(Order No.=FIELD(Sales Order No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(37; "Sales Order No."; Code[20])
        {
        }
        field(38; "Issued Serial No."; Code[20])
        {
        }
        field(39; "Issued MFG"; Code[10])
        {
        }
        field(40; GRN; Boolean)
        {
        }
        field(41; "Issue Date"; Date)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50000; "OE/TRD"; Option)
        {
            CalcFormula = Lookup("Posted Battery Job Header".OE/Trd WHERE (Job Card No.=FIELD(Job Card No.)));
                FieldClass = FlowField;
                OptionCaption = 'TR,OE,PW,MO,MT,MW';
                OptionMembers = TR,OE,PW,MO,MT,MW;
        }
        field(50001; "Dealer Name"; Text[50])
        {
            CalcFormula = Lookup("Posted Battery Job Header"."Customer Agent Name" WHERE(Job Card No.=FIELD(Job Card No.)));
                FieldClass = FlowField;
        }
        field(50002; CutAndDoc; Boolean)
        {
            FieldClass = Normal;
        }
        field(50003; "Battery MFG"; Text[30])
        {
            CalcFormula = Lookup("Posted Battery Job Header".MFG WHERE(Job Card No.=FIELD(Job Card No.)));
                FieldClass = FlowField;
        }
        field(50004; "Battery Serial No."; Code[20])
        {
            CalcFormula = Lookup("Posted Battery Job Header"."Battery Serial No." WHERE(Job Card No.=FIELD(Job Card No.)));
                FieldClass = FlowField;
        }
        field(50005; "Settled Date"; Date)
        {
            Editable = false;
        }
        field(50006; "Pre-Assigned No."; Code[20])
        {
            Editable = false;
        }
        field(50007; Apply; Boolean)
        {
        }
        field(50008; Settled; Boolean)
        {
            Editable = false;
        }
        field(50009; "Invoice No."; Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header".No. WHERE(Pre-Assigned No.=FIELD(Pre-Assigned No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Job Card No.")
        {
            Clustered = true;
        }
        key(Key2;"Claim No.")
        {
        }
        key(Key3;"Claim Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
          IF "Claim No." = '' THEN
           BEGIN
            SerMgtSetup.GET;
            SerMgtSetup.TESTFIELD(SerMgtSetup."Claim No.");
            NoSeriesMgmt.InitSeries(SerMgtSetup."Claim No.",xRec."No. Series",0D,"Claim No.","No. Series");
        
        // Code to update exide claim value to true
        /*
         GblJobCardInfo.SETRANGE("Job Card No.","Job Card No.");
         IF GblJobCardInfo.FINDFIRST THEN BEGIN
          GblJobCardInfo."Exide Claim" := TRUE;
          GblJobCardInfo.MODIFY;
         END;
         */
        
         PostedJobHeader.SETRANGE("Job Card No.","Job Card No.");
         IF PostedJobHeader.FINDFIRST THEN BEGIN
            PostedJobHeader."Exide Claim" := TRUE;
            PostedJobHeader.Date := "Claim Date";
            PostedJobHeader."Claim No." := "Claim No.";
            PostedJobHeader.MODIFY;
        
         "Issue Part Description" := PostedJobHeader."Battery Description";
             "Issue Qty." := 1 ;
             // BATPartNumVar.GET("Battery Part No.");
              //"Battery Description" := BATPartNumVar.Description;
             // "Battery Type" := BATPartNumVar."Product Subgroup Code";
             GblSalesPrice.SETRANGE(GblSalesPrice."Item No.", PostedJobHeader."Battery Part No.");
             IF GblSalesPrice.FINDFIRST THEN BEGIN
             "Sales Rate" := GblSalesPrice."Unit Price";
        
             Total := "Sales Rate" * "Issue Qty.";
             END;
        
          END;
        END;
        
        
         UserSetup.GET(USERID);
         "Responsibility Center" := UserSetup."Default Responsibility Center";
         "Accountability Center" := UserSetup."Default Accountability Center";
         "Location Code" := UserSetup."Default Location";
         "Dimension 1" := UserSetup."Shortcut Dimension 1 Code";
         "Dimension 2" := UserSetup."Shortcut Dimension 2 Code";
         "User ID" := USERID;

    end;

    var
        GblJobCardInfo: Record "33019884";
        SerMgtSetup: Record "5911";
        NoSeriesMgmt: Codeunit "396";
        ExideClaimTable: Record "33019886";
        GblBattInfo: Record "27";
        GblSalesPrice: Record "7002";
        GblExideClaimFactor: Record "33019888";
        Item: Record "27";
        LookUpMgt: Codeunit "25006003";
        PostedJobHeader: Record "33019894";
        UserSetup: Record "91";
        ScrapNo: Code[20];
        SalesPrice: Record "7002";
        ScrapAmount: Decimal;
        "Claim %": Decimal;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
         WITH ExideClaimTable DO
          BEGIN
           ExideClaimTable := Rec;
           SerMgtSetup.GET;
           SerMgtSetup.TESTFIELD(SerMgtSetup."Claim No.");
           IF NoSeriesMgmt.SelectSeries(SerMgtSetup."Claim No.",xRec."No. Series","No. Series") THEN
             BEGIN
              SerMgtSetup.GET;
              SerMgtSetup.TESTFIELD(SerMgtSetup."Claim No.");
              NoSeriesMgmt.SetSeries("Claim No.");
              Rec := ExideClaimTable;
              EXIT(TRUE);
             END;
          END;
    end;

    [Scope('Internal')]
    procedure AssistEdit1(): Boolean
    begin
         WITH ExideClaimTable DO
          BEGIN
           ExideClaimTable := Rec;
           SerMgtSetup.GET;
           SerMgtSetup.TESTFIELD(SerMgtSetup."Issue No.");
           IF NoSeriesMgmt.SelectSeries(SerMgtSetup."Issue No.",xRec."No. Series1","No. Series1") THEN
             BEGIN
              SerMgtSetup.GET;
              SerMgtSetup.TESTFIELD(SerMgtSetup."Issue No.");
              NoSeriesMgmt.SetSeries("Issue No.");
              Rec := ExideClaimTable;
              EXIT(TRUE);
             END;
          END;
    end;

    [Scope('Internal')]
    procedure ModifyAll(Apply: Boolean;var ExideClaim: Record "33019886";PreAssignNo: Code[20])
    var
        RecExideClaim: Record "33019886";
    begin
        RecExideClaim.COPYFILTERS(ExideClaim);
        IF RecExideClaim.FINDFIRST THEN REPEAT
          RecExideClaim.TESTFIELD(Settled,FALSE);
          RecExideClaim.Apply := Apply;
          IF Apply THEN
            RecExideClaim."Pre-Assigned No." := PreAssignNo
          ELSE
            RecExideClaim."Pre-Assigned No." := '';
          RecExideClaim.MODIFY;
        UNTIL RecExideClaim.NEXT=0;
    end;
}

