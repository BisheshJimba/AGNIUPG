pageextension 50288 pageextension50288 extends "Fixed Asset Card"
{
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "FA Posting Group"
    // 
    // 07.03.2014 Elva Baltic P7 #R063 MMG7.00
    //   * Added FA prescript report
    // 
    // 05.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added fields:
    //     - "Sales Date"
    //     - "Fuel Type"
    // 
    // 04.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added FastTab: "Vehicle"
    //   * Added fields:
    //     - "Vehicle Serial No."
    //     - "VIN"
    //     - "Make Code"
    //     - "Model Code"
    Editable = false;
    Editable = false;
    Editable = false;
    Caption = 'FA Location Code';
    Editable = Promoted;
    Editable = "Warranty Expiry Date";
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Modification (Level) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Modification (SourceExpr) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Modification (SourceExpr) on "DepreciationMethod(Control 23)".


        //Unsupported feature: Property Modification (Level) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Modification (SourceExpr) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Modification (Level) on "NumberOfDepreciationYears(Control 19)".


        //Unsupported feature: Property Modification (SourceExpr) on "NumberOfDepreciationYears(Control 19)".


        //Unsupported feature: Property Modification (Level) on "DepreciationEndingDate(Control 17)".


        //Unsupported feature: Property Modification (SourceExpr) on "DepreciationEndingDate(Control 17)".


        //Unsupported feature: Property Modification (Level) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Modification (SourceExpr) on "AddMoreDeprBooks(Control 15)".



        //Unsupported feature: Code Modification on "Control 45.OnLookup".

        //trigger OnLookup(var Text: Text): Boolean
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "FA Class Code" <> '' THEN
          FASubclass.SETFILTER("FA Class Code",'%1|%2','',"FA Class Code");

        IF FASubclass.GET("FA Subclass Code") THEN;
        IF PAGE.RUNMODAL(0,FASubclass) = ACTION::LookupOK THEN BEGIN
          Text := FASubclass.Code;
          EXIT(TRUE);
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF "FA Class Code" <> '' THEN
          FASubclass.SETFILTER("FA Class Code (Std)",'%1|%2','',"FA Class Code");
        #3..8
        */
        //end;
        modify(DepreciationBookCode)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Deletion (CaptionML) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Deletion (ToolTipML) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Deletion (TableRelation) on "DepreciationBookCode(Control 25)".


        //Unsupported feature: Property Deletion (Importance) on "DepreciationBookCode(Control 25)".

        modify(FAPostingGroup)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Deletion (CaptionML) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Deletion (ToolTipML) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Deletion (TableRelation) on "FAPostingGroup(Control 31)".


        //Unsupported feature: Property Deletion (Importance) on "FAPostingGroup(Control 31)".

        modify(DepreciationMethod)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "DepreciationMethod(Control 23)".


        //Unsupported feature: Property Deletion (CaptionML) on "DepreciationMethod(Control 23)".


        //Unsupported feature: Property Deletion (ToolTipML) on "DepreciationMethod(Control 23)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "DepreciationMethod(Control 23)".

        modify(DepreciationStartingDate)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Deletion (CaptionML) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Deletion (ToolTipML) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "DepreciationStartingDate(Control 21)".


        //Unsupported feature: Property Deletion (ShowMandatory) on "DepreciationStartingDate(Control 21)".

        modify(NumberOfDepreciationYears)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "NumberOfDepreciationYears(Control 19)".


        //Unsupported feature: Property Deletion (CaptionML) on "NumberOfDepreciationYears(Control 19)".


        //Unsupported feature: Property Deletion (ToolTipML) on "NumberOfDepreciationYears(Control 19)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "NumberOfDepreciationYears(Control 19)".

        modify(DepreciationEndingDate)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "DepreciationEndingDate(Control 17)".


        //Unsupported feature: Property Deletion (CaptionML) on "DepreciationEndingDate(Control 17)".


        //Unsupported feature: Property Deletion (ToolTipML) on "DepreciationEndingDate(Control 17)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "DepreciationEndingDate(Control 17)".

        modify(AddMoreDeprBooks)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (DrillDown) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (Editable) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (Style) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (StyleExpr) on "AddMoreDeprBooks(Control 15)".


        //Unsupported feature: Property Deletion (ShowCaption) on "AddMoreDeprBooks(Control 15)".

        addafter("Control 2")
        {
            field("Old FA No."; Rec."Old FA No.")
            {
            }
        }
        addafter("Control 4")
        {
            field("Description 2"; Rec."Description 2")
            {
            }
            field("Tax Renew Date"; "Tax Renew Date")
            {
            }
            field("Blue Book Renew Date"; "Blue Book Renew Date")
            {
            }
            field("Responsible Department"; "Responsible Department")
            {
            }
            field("HS Code"; "HS Code")
            {
            }
        }
        addafter("Control 52")
        {
            field("Location Code"; Rec."Location Code")
            {
            }
        }
        addafter("Control 22")
        {
            field("Core Assets"; "Core Assets")
            {
            }
        }
        addafter("Control 32")
        {
            field("Purchase Order No."; "Purchase Order No.")
            {
            }
            field("Vendor Invoice No."; "Vendor Invoice No.")
            {
            }
            field("Bill Amount Ex. VAT"; "Bill Amount Ex. VAT")
            {
            }
            field(Saved; Saved)
            {
            }
        }
        addfirst("Control 27")
        {
            field(DepreciationBookCode; FADepreciationBook."Depreciation Book Code")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Book Code';
                Importance = Additional;
                TableRelation = "Depreciation Book";
                ToolTip = 'Specifies the depreciation book that is assigned to the fixed asset.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("Depreciation Book Code");
                    SaveSimpleDepriciationBook(xRec."No.");
                    ShowAcquireNotification;
                end;
            }
            field(FAPostingGroup; FADepreciationBook."FA Posting Group")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Posting Group';
                Importance = Additional;
                TableRelation = "FA Posting Group";
                ToolTip = 'Specifies which posting group is used for the depreciation book when posting fixed asset transactions.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("FA Posting Group");
                    SaveSimpleDepriciationBook(xRec."No.");
                    ShowAcquireNotification;
                end;
            }
            field(DepreciationMethod; FADepreciationBook."Depreciation Method")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Method';
                ToolTip = 'Specifies how depreciation is calculated for the depreciation book.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("Depreciation Method");
                    SaveSimpleDepriciationBook(xRec."No.");
                end;
            }
        }
        addfirst("Control 33")
        {
            field(DepreciationStartingDate; FADepreciationBook."Depreciation Starting Date")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Starting Date';
                ShowMandatory = true;
                ToolTip = 'Specifies the date on which depreciation of the fixed asset starts.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("Depreciation Starting Date");
                    SaveSimpleDepriciationBook(xRec."No.");
                    ShowAcquireNotification;
                end;
            }
            field(NumberOfDepreciationYears; FADepreciationBook."No. of Depreciation Years")
            {
                ApplicationArea = FixedAssets;
                Caption = 'No. of Depreciation Years';
                ToolTip = 'Specifies the length of the depreciation period, expressed in years.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("No. of Depreciation Years");
                    SaveSimpleDepriciationBook(xRec."No.");
                    ShowAcquireNotification;
                end;
            }
            field(DepreciationEndingDate; FADepreciationBook."Depreciation Ending Date")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Depreciation Ending Date';
                ToolTip = 'Specifies the date on which depreciation of the fixed asset ends.';

                trigger OnValidate()
                begin
                    LoadDepreciationBooks;
                    FADepreciationBook.VALIDATE("Depreciation Ending Date");
                    SaveSimpleDepriciationBook(xRec."No.");
                end;
            }
        }
        addfirst("Control 38")
        {
            field(AddMoreDeprBooks; AddMoreDeprBooksLbl)
            {
                ApplicationArea = FixedAssets;
                DrillDown = true;
                Editable = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = TRUE;

                trigger OnDrillDown()
                begin
                    Simple := NOT Simple;
                end;
            }
        }
        addafter("Control 37")
        {
            field("Insurance Expiry Date"; "Insurance Expiry Date")
            {
            }
            field(Kilometrage; Kilometrage)
            {
            }
            field("Renewal Date"; "Renewal Date")
            {
            }
        }
        addafter("Control 1903524101")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
            }
        }
        addafter(DepreciationBookCode)
        {
            field("Engine No."; "Engine No.")
            {
            }
            field("VIN No."; "VIN No.")
            {
            }
            field("Vehicle Registration Number"; "Vehicle Registration Number")
            {
            }
            field("Seat Capacity"; Rec."Seat Capacity")
            {
            }
        }
        moveafter("Control 27"; "Control 33")
        moveafter("Control 33"; BookValue)
        moveafter("Control 38"; DepreciationBook)
        moveafter(DepreciationBook; FAPostingGroup)
        moveafter("Control 31"; "Control 1903524101")
        moveafter("Control 28"; AddMoreDeprBooks)
        moveafter("Control 15"; DepreciationEndingDate)
        moveafter("Control 17"; NumberOfDepreciationYears)
        moveafter("Control 19"; DepreciationStartingDate)
        moveafter("Control 21"; DepreciationMethod)
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 50".


        //Unsupported feature: Property Modification (RunPageView) on "Action 7".


        //Unsupported feature: Property Modification (RunPageView) on "Action 8".

        addafter("Action 50")
        {
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the customer card?') THEN BEGIN //MIN 4/30/2019
                        Saved := TRUE;
                        Rec.MODIFY;
                    END;
                    Rec.TESTFIELD(Description);
                    Rec.TESTFIELD("FA Class Code");
                    Rec.TESTFIELD("FA Subclass Code");
                    Rec.TESTFIELD("FA Location Code");
                    Rec.TESTFIELD("Location Code");
                    Rec.TESTFIELD("FA Posting Group");
                end;
            }
        }
        addafter("Action 68")
        {
            action("FA Transfer")
            {
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019903;
                RunPageLink = FA No.=FIELD(No.);
                RunPageMode = Create;
            }
            action("FA Transfer History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33019904;
                                RunPageLink = FA No.=FIELD(No.);
            }
        }
        addafter("Action 11")
        {
            action("Maintenance Ledg. Entries")
            {
                RunObject = Page 33020089;
                                RunPageLink = Document Subclass=FIELD(No.);
                RunPageView = SORTING(Document No.,Document Class,Document Subclass,Posting Date);
            }
        }
        addafter("Action 1903807106")
        {
            action("Fixed Assets Card")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(FixedAsset);
                    REPORT.RUNMODAL(50049,TRUE,TRUE,FixedAsset);
                end;
            }
            action("Print Barcode Label")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50061;
            }
        }
    }

    var
        FixedAsset: Record "5600";
        SaveFAPageConf: Label 'You must first save the Fixed Assets page before close it.';
        CompInfo: Record "79";


    //Unsupported feature: Code Modification on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SaveSimpleDepriciationBook("No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CompInfo.GET;
        IF CompInfo."Balaju Auto Works" THEN
          IF Rec."FA Class Code" = 'BUS/AUTO' THEN BEGIN
            Rec.TESTFIELD("VIN No.");
            Rec.TESTFIELD("Engine No.");
            Rec.TESTFIELD("Responsible Department");
          END;
        SaveSimpleDepriciationBook("No.");
        IF NOT Saved THEN //MIN 4/30/2019
          ERROR(SaveFAPageConf);
        */
    //end;
}

