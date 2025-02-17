pageextension 50108 pageextension50108 extends "Vendor Card"
{

    //Unsupported feature: Property Insertion (Name) on ""Vendor Card"(Page 26)".

    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = LCFieldView;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "VendorStatisticsFactBox(Control 1904651607)".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 17".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 19".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorHistBuyFromFactBox(Control 1903435607)".


        //Unsupported feature: Property Modification (SubPageLink) on "VendorHistPayToFactBox(Control 1906949207)".

        addafter("Control 4")
        {
            field("Name 2"; Rec."Name 2")
            {
            }
        }
        addafter("Control 45")
        {
            field("TDS Balance (Open)"; "TDS Balance (Open)")
            {
            }
            field("Vendor Type"; "Vendor Type")
            {
                Editable = false;
            }
            field("Interest Rate"; "Interest Rate")
            {
                Visible = FieldsView;
            }
            field("Maturity Date"; "Maturity Date")
            {
                Visible = FieldsView;
            }
            field("Maturity Period"; "Maturity Period")
            {
                Visible = FieldsView;
            }
            field("Other Loan Type"; "Other Loan Type")
            {
                Visible = OtherLoanView;
            }
            field("Repayment Schedule"; "Repayment Schedule")
            {
                Visible = OtherLoanView;
            }
            field("Sys LC No."; "Sys LC No.")
            {
                Visible = SysLCView;
            }
            field("Deal Date"; "Deal Date")
            {
                Visible = FieldsView;
            }
        }
        addafter("Control 55")
        {
            field("Bank Account"; "Bank Account")
            {
            }
            field(Saved; Saved)
            {
                Editable = false;
            }
            part("Repayment Details"; 33020272)
            {
                Caption = 'Repayment Details';
                SubPageLink = No.=FIELD(No.);
                    Visible = OtherLoanView;
            }
        }
        addafter("Control 10")
        {
            field("Province No."; "Province No.")
            {
            }
        }
        addafter("Control 56")
        {
            field("Mobile No."; "Mobile No.")
            {
            }
        }
        addafter("Control 23")
        {
            field(IRD; IRD)
            {
                Caption = 'Check VAT Registration';
                Editable = false;
                ExtendedDatatype = URL;
                Visible = LCFieldView;
            }
        }
        addafter("Control 30")
        {
            field("TDS Posting Group"; "TDS Posting Group")
            {
            }
        }
        addafter("Control 1905885101")
        {
            group("NCHL-NPI Integration")
            {
                field(Category; Category)
                {
                }
                field("App Id"; "App Id")
                {
                }
                field("App Group"; "App Group")
                {
                }
                field("List of Custom"; "List of Custom")
                {
                }
            }
        }
        moveafter("Control 4"; "Control 92")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 184".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 68".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageView) on "Action 70".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 66".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 69".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 67".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 20".

        addafter(VendorReportSelections)
        {
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the Vendor card?') THEN BEGIN //MIN 4/28/2019
                        Saved := TRUE;
                        Rec.MODIFY;
                    END;
                    Rec.TESTFIELD(Name);
                    Rec.TESTFIELD("Gen. Bus. Posting Group");
                    Rec.TESTFIELD("Vendor Posting Group");
                    Rec.TESTFIELD("VAT Bus. Posting Group");
                    //TESTFIELD("Bank Account"); //Min
                    IF "Vendor Type" = "Vendor Type"::" " THEN BEGIN
                        Rec.TESTFIELD(Address);
                        Rec.TESTFIELD(City);
                        Rec.TESTFIELD("Mobile No.");
                        Rec.TESTFIELD("VAT Registration No.");
                    END;
                    IF "Vendor Type" = "Vendor Type"::"TR Loan" THEN BEGIN
                        Rec.TESTFIELD("Interest Rate");
                        Rec.TESTFIELD("Maturity Date");
                        Rec.TESTFIELD("Maturity Period");
                        Rec.TESTFIELD("Sys LC No.");
                        Rec.TESTFIELD("Deal Date");
                    END;
                    IF "Vendor Type" = "Vendor Type"::LC THEN
                        Rec.TESTFIELD("Invoice Disc. Code");
                end;
            }
        }
    }

    var
        IRD: Text[250];
        VendorTypeFilter: Text[250];
        [InDataSet]
        LCFieldView: Boolean;
        [InDataSet]
        FieldsView: Boolean;
        [InDataSet]
        OtherLoanView: Boolean;
        [InDataSet]
        SysLCView: Boolean;
        VendPostingGrp: Record "93";
        SaveVendorPageConf: Label 'You must first save the vendor card  page before close it.';


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ActivateFields;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ActivateFields;

    IRD := 'https://ird.gov.np/PanSearch';

    //***SM 16-07-2013 to filter the vendors by the vendor type
    LCFieldView := ("Vendor Type" = "Vendor Type"::LC) OR ("Vendor Type" = "Vendor Type"::"TR Loan") OR
                   ("Vendor Type" = "Vendor Type"::"Other Loan");

    IF "Vendor Type" = "Vendor Type"::LC THEN BEGIN
      LCFieldView := FALSE;
      FieldsView := FALSE;
    END ELSE IF "Vendor Type" = "Vendor Type"::"TR Loan" THEN BEGIN
      LCFieldView := FALSE;
      FieldsView := TRUE;
      SysLCView := TRUE;
    END ELSE IF "Vendor Type" = "Vendor Type"::"Other Loan" THEN BEGIN
      SysLCView := FALSE;
      OtherLoanView := TRUE;
      LCFieldView := FALSE;
      FieldsView := TRUE;
    END ELSE BEGIN
      OtherLoanView := FALSE;
      LCFieldView := TRUE;
      FieldsView := FALSE;
    END;

    //***SM 16-07-2013 to filter the vendors by the vendor type
    */
    //end;


    //Unsupported feature: Code Insertion on "OnClosePage".

    //trigger OnClosePage()
    //begin
    /*

    VendPostingGrp.GET("Vendor Posting Group");
    IF VendPostingGrp."Check Duplicate VAT Reg. No." THEN BEGIN
    IF "VAT Registration No." = '' THEN BEGIN
      MESSAGE('Please enter VAT Registration No. before closing the Vendor Card.');
      PAGE.RUNMODAL(26,Rec);
    END;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF GUIALLOWED THEN
      IF "No." = '' THEN
        IF DocumentNoVisibility.VendorNoSeriesIsDefault THEN
          NewMode := TRUE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    //***SM 16-07-2013 to filter the vendors by the vendor type
    LCFieldView := TRUE;

    CASE VendorTypeFilter OF
        FORMAT("Vendor Type"::LC): BEGIN
          "Vendor Type" := "Vendor Type"::LC;
          LCFieldView := FALSE;
          FieldsView := FALSE;
        END;
        FORMAT("Vendor Type"::"TR Loan"): BEGIN
          "Vendor Type" := "Vendor Type"::"TR Loan";
          LCFieldView := FALSE;
          FieldsView := TRUE;
        END;
        FORMAT("Vendor Type"::"Other Loan"): BEGIN
          "Vendor Type" := "Vendor Type"::"Other Loan";
          OtherLoanView := TRUE;
          LCFieldView := FALSE;
          FieldsView := TRUE;
        END;
    END;
    //***SM 16-07-2013 to filter the vendors by the vendor type
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ActivateFields;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ActivateFields;
    IsOfficeAddin := OfficeMgt.IsAvailable;

    //***SM 16-07-2013 to filter the vendors by the vendor type
    FILTERGROUP(3);
    VendorTypeFilter := GETFILTER("Vendor Type");
    FILTERGROUP(0);


    IF "Vendor Type" = "Vendor Type"::LC THEN BEGIN
      LCFieldView := FALSE;
      FieldsView := FALSE;
    END ELSE IF "Vendor Type" = "Vendor Type"::"TR Loan" THEN BEGIN
      LCFieldView := FALSE;
      FieldsView := TRUE;
      SysLCView := TRUE;
    END ELSE IF "Vendor Type" = "Vendor Type"::"Other Loan" THEN BEGIN
      OtherLoanView := TRUE;
      LCFieldView := FALSE;
      FieldsView := TRUE;
      SysLCView := FALSE;
    END ELSE BEGIN
      OtherLoanView := FALSE;
      LCFieldView := TRUE;
      FieldsView := FALSE;
    END;
    //***SM 16-07-2013 to filter the vendors by the vendor type
    */
    //end;


    //Unsupported feature: Code Insertion on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //begin
    /*
    IF NOT Saved THEN //MIN 4/28/2019
      ERROR(SaveVendorPageConf);
    */
    //end;

    //Unsupported feature: Property Deletion (Importance) on "Control2".


    //Unsupported feature: Insertion on "Control23".

}

