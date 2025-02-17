tableextension 50255 tableextension50255 extends "Sales Header Archive"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 20.02.2015 EB.P7 #Arch Ret.Orders
    //   Renewed EDMS fields from Sales Header
    // 
    // 28.07.2008. EDMS P2
    //   * Added fields:
    //               Guarranty Claim No.
    //               Vehicle Item Charge No.
    //               DMS Variable Field 25006800
    //               DMS Variable Field 25006801
    //               DMS Variable Field 25006802
    //               Kilometrage
    //               Automatic CM Item Return
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Bill-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name"(Field 13)".


        //Unsupported feature: Property Modification (Data type) on ""Ship-to Name 2"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount Including VAT"(Field 61)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Sell-to Customer Name 2"(Field 80)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Archived Versions"(Field 145)".

        modify("Sales Quote No.")
        {
            TableRelation = "Sales Header".No. WHERE(Document Type=CONST(Quote),
                                                      No.=FIELD(Sales Quote No.));
        }
        modify("Opportunity No.")
        {
            TableRelation = Opportunity.No. WHERE(Contact No.=FIELD(Sell-to Contact No.),
                                                   Closed=CONST(No));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Late Order Shipping"(Field 5795)".

        field(50001;"Battery Document";Boolean)
        {
        }
        field(50055;"Invertor Serial No.";Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(70000;"Dealer PO No.";Code[20])
        {
            Description = 'For Dealer Portal';
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

            trigger OnValidate()
            var
                recSalesLine: Record "37";
                tcDMS001: Label 'Do you want to change lines too?';
            begin
            end;
        }
        field(25006005;"Prepmt. Bill-to Cust. Changed";Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006007;"Quote No.";Code[20])
        {
        }
        field(25006120;"Service Document No.";Code[20])
        {
            Caption = 'Service Document No.';
        }
        field(25006130;"Service Document";Boolean)
        {
            Caption = 'Service Document';
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
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
            end;
        }
        field(25006276;"Warranty Claim No.";Code[20])
        {
            Caption = 'Warranty Claim No.';
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
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006390;"Vehicle Item Charge No.";Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
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
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                VehicleCard: Page "25006032";
            begin
            end;
        }
        field(25006680;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record "18";
                ContractTemp: Record "25006016" temporary;
            begin
            end;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,36,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,36,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,36,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006995;"Variable Field Run 1";Decimal)
        {
            CaptionClass = '7,36,25006995';
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006996';
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006997';
        }
        field(33019833;"Job Finished Date";Date)
        {
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
                
                //Code to check for LC Amendment and insert Bank LC No. and LC Amend No. (LC Version No.) if LC is amended atleast once.
                /*
                LCAmendDetail.RESET;
                LCAmendDetail.SETRANGE("No.","Sys. LC No.");
                IF LCAmendDetail.FIND('+') THEN BEGIN
                  IF NOT LCAmendDetail.Closed THEN BEGIN
                    IF LCAmendDetail.Released THEN BEGIN
                      "Bank LC No." := LCAmendDetail."Bank Amended No.";
                      "LC Amend No." := LCAmendDetail."Version No.";
                      MODIFY;
                    END ELSE
                      ERROR(Text33020011);
                  END ELSE
                    ERROR(Text33020012);
                END ELSE BEGIN
                  LCDetail.RESET;
                  LCDetail.SETRANGE("No.","Sys. LC No.");
                  IF LCDetail.FIND('-') THEN BEGIN
                    IF NOT LCDetail.Closed THEN BEGIN
                      IF LCDetail.Released THEN BEGIN
                        "Bank LC No." := LCDetail."LC\DO No.";
                        MODIFY;
                      END ELSE
                        ERROR(Text33020013);
                    END ELSE
                      ERROR(Text33020014);
                  END;
                END;
                */

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
        field(33020017;"Financed By No.";Code[20])
        {
            Description = 'Financed Bank';
            TableRelation = Contact.No. WHERE (No.=FILTER(FI*));
        }
        field(33020018;"Re-Financed By";Code[20])
        {
            Description = 'To Account';
            TableRelation = Contact.No. WHERE (No.=FILTER(FI*));
        }
        field(33020019;"Financed Amount";Decimal)
        {
        }
        field(33020020;"Financed By";Text[50])
        {
            CalcFormula = Lookup(Contact.Name WHERE (No.=FIELD(Financed By No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020235;"Job Type";Code[20])
        {
            Editable = true;
            FieldClass = Normal;
        }
        field(33020236;"Package No.";Code[20])
        {
            Editable = true;
            TableRelation = "Service Package".No.;
        }
        field(33020237;"Advance Payment Mode";Option)
        {
            OptionMembers = Cash,Bank;

            trigger OnValidate()
            begin
                //TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020238;"Advance Payment Account";Code[10])
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020239;"Advance Cheque No";Code[10])
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020240;"Advance Cheque Date";Code[10])
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020241;"Advance Amount";Decimal)
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Advance Received",FALSE);
            end;
        }
        field(33020242;"Advance Received";Boolean)
        {
            Editable = false;
        }
        field(33020243;"Advance Reversed";Boolean)
        {
            Editable = false;
        }
        field(33020244;"Job Type (Before Posting)";Code[20])
        {
        }
        field(33020245;"Debit Note";Boolean)
        {
            Editable = true;
        }
        field(33020246;"VF Loan No";Code[10])
        {
        }
        field(33020247;"Warranty Settlement";Boolean)
        {
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020299;"Warranty Settlement (Battery)";Boolean)
        {
        }
        field(33020500;"Booked Date";Date)
        {
            Description = 'If the booking is for the month of april 2013, choose01/04/2013';

            trigger OnValidate()
            begin
                /*
                SalesLine.RESET;
                SalesLine.SETRANGE("Document No.","No.");
                IF SalesLine.FINDFIRST THEN BEGIN
                  SalesLine."Booked Date" := "Booked Date";
                  SalesLine.MODIFY;
                END;
                */

            end;
        }
        field(33020510;"Tender Sales";Boolean)
        {
        }
        field(33020511;"Job Category";Option)
        {
            Editable = false;
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020512;"Advance Payment";Boolean)
        {
        }
        field(33020513;"Scheme Type";Code[20])
        {
            TableRelation = "Service Scheme Line";
        }
        field(33020514;"Mobile No.";Code[50])
        {
            CalcFormula = Lookup(Customer."Mobile No." WHERE (No.=FIELD(Sell-to Customer No.)));
            FieldClass = FlowField;
        }
        field(33020515;"Latest Flipped Date";Date)
        {
            Editable = false;
        }
        field(33020600;"Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,6th type service,7th type Service,8th type Service,Bonus,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service","6th type Service","7th type Service"," 8th type Service",Bonus,Other;

            trigger OnValidate()
            var
                NotAllowed: Label 'Job Category must be Under Warranty';
            begin
            end;
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
    }

    var
        cuLookUpMgt: Codeunit "25006003";
}

