tableextension 50404 tableextension50404 extends "Return Receipt Header"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name 2"(Field 6)".

        modify("Bill-to City")
        {
            TableRelation = IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name"(Field 13)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".

        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name 2"(Field 80)".

        modify("Sell-to City")
        {
            TableRelation = IF (Sell-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
        }
        modify("Bill-to Post Code")
        {
            TableRelation = IF (Bill-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
        }
        modify("Sell-to Post Code")
        {
            TableRelation = IF (Sell-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }
        field(50055;"Invertor Serial No.";Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(60000;"Allotment Date";Date)
        {
        }
        field(60001;"Allotment Time";Time)
        {
        }
        field(60002;"Confirmed Time";Time)
        {
        }
        field(60003;"Confirmed Date";Date)
        {
        }
        field(70000;"Dealer PO No.";Code[20])
        {
            Description = 'For Dealer Portal';
        }
        field(70001;"Dealer Tenant ID";Code[30])
        {
            Description = 'For Dealer Portal';
        }
        field(70002;"Dealer Line No.";Integer)
        {
            Description = 'For Dealer Portal';
        }
        field(70003;"Order Type";Option)
        {
            OptionCaption = ' ,Stock order,Rush Order,VOR order,Accidental';
            OptionMembers = " ","Stock order","Rush Order","VOR order",Accidental;
        }
        field(70004;"Swift Code";Text[50])
        {
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006007;"Quote No.";Code[20])
        {
            Caption = 'Quote No.';
        }
        field(25006120;"Service Order No. EDMS";Code[20])
        {
            Caption = 'Service Order No. EDMS';
        }
        field(25006130;"Service Document EDMS";Boolean)
        {
            Caption = 'Service Document EDMS';
        }
        field(25006140;"Order Creator";Code[10])
        {
            Caption = 'Order Creator';
            Description = 'Internal';
            TableRelation = Salesperson/Purchaser;
        }
        field(25006150;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Make;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006372;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                recModelVersion: Record "27";
            begin
                recModelVersion.RESET;
                IF cuLookUpMgt.LookUpModelVersion(recModelVersion,"Model Version No.","Make Code","Model Code") THEN;
            end;
        }
        field(25006377;"Quote Applicable To Date";Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006391;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392;"Mobile Phone No.";Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(25006670;VIN;Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Vehicle;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details".No. WHERE (Transaction Type=CONST(Sale),
                                                    Issued To/Received From=FIELD(Sell-to Customer No.),
                                                    Released=CONST(Yes),
                                                    Closed=CONST(No));

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            Caption = 'Amendment No.';
            TableRelation = "LC Amend. Details"."Version No." WHERE (No.=FIELD(Sys. LC No.));
        }
        field(33020608;"Province No.";Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
        field(33020609;"Dealer VIN";Code[20])
        {
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
    }


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 3)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        WITH ReturnRcptHeader DO BEGIN
          COPY(Rec);
          ReportSelection.PrintWithGUIYesNo(
            ReportSelection.Usage::"S.Ret.Rcpt.",ReturnRcptHeader,ShowRequestForm,"Bill-to Customer No.");
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
            ReportSelection.Usage::"S.Ret.Rcpt.",ReturnRcptHeader,ShowRequestForm,"Bill-to Customer No.");         //EDMS Upgrade to 2017
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 4)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        {
        #1..5
        }
        */
    //end;

    var
        cuLookUpMgt: Codeunit "25006003";
}

