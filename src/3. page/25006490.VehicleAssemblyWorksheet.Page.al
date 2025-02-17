page 25006490 "Vehicle Assembly Worksheet"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified Amount - OnValidate(), Usert Profile Setup to Branch Profile Setup
    //   Modified Sales Price - OnValidate(), Usert Profile Setup to Branch Profile Setup
    // 
    // 23.05.2013 Elva Baltic P15
    //   * Added function - CheckDuplicates(by

    AutoSplitKey = true;
    Caption = 'Vehicle Assembly Worksheet';
    DataCaptionFields = "Assembly ID", "Line No.", "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = Table25006380;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Assembly ID"; "Assembly ID")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Option Type"; "Option Type")
                {
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field("Option Code"; "Option Code")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OwnOptions: Page "25006499";
                        ManOptions: Page "25006450";
                        ManOption: Record "25006370";
                        OwnOption: Record "25006372";
                    begin
                        CASE "Option Type" OF
                            "Option Type"::"Vehicle Base":
                                ;
                            "Option Type"::"Manufacturer Option":
                                BEGIN
                                    ManOption.RESET;
                                    ManOption.SETRANGE("Make Code", "Make Code");
                                    ManOption.SETRANGE("Model Code", "Model Code");
                                    ManOption.SETRANGE("Model Version No.", "Model Version No.");
                                    ManOption.SETRANGE(Type, "Option Subtype");
                                    CLEAR(ManOptions);
                                    ManOptions.SETTABLEVIEW(ManOption);
                                    IF "Option Code" <> '' THEN BEGIN
                                        ManOption.SETRANGE("Option Code", "Option Code");
                                        IF ManOption.FINDSET THEN;
                                        ManOption.SETRANGE("Option Code");
                                        ManOptions.SETRECORD(ManOption);
                                    END;
                                    ManOptions.LOOKUPMODE(TRUE);
                                    IF ManOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                        ManOptions.GETRECORD(ManOption);
                                        VALIDATE("Option Code", ManOption."Option Code");
                                    END;
                                END;
                            "Option Type"::"Own Option":
                                BEGIN
                                    OwnOption.RESET;
                                    OwnOption.SETRANGE("Make Code", "Make Code");
                                    OwnOption.SETRANGE("Model Code", "Model Code");
                                    CLEAR(OwnOptions);
                                    OwnOptions.SETTABLEVIEW(OwnOption);
                                    IF "Option Code" <> '' THEN BEGIN
                                        OwnOption.SETRANGE("Option Code", "Option Code");
                                        IF OwnOption.FINDSET THEN;
                                        OwnOption.SETRANGE("Option Code");
                                        OwnOptions.SETRECORD(OwnOption);
                                    END;
                                    OwnOptions.LOOKUPMODE(TRUE);
                                    IF OwnOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                        OwnOptions.GETRECORD(OwnOption);
                                        VALIDATE("Option Code", OwnOption."Option Code");
                                    END;
                                END;
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                field("External Code"; "External Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Sales Price"; "Sales Price")
                {

                    trigger OnValidate()
                    begin
                        IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
                            IF UserProfile."Vehicle Sales Disc. Check" THEN
                                ERROR(Text100);
                    end;
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
                            IF UserProfile."Vehicle Sales Disc. Check" THEN
                                ERROR(Text100);
                    end;
                }
                field(Standard; Standard)
                {
                }
                field("Serial No."; "Serial No.")
                {
                    Visible = false;
                }
                field(Posted; Posted)
                {
                    Visible = false;
                }
                field("<Assembly ID 2>"; "Assembly ID")
                {
                    Visible = false;
                }
                field("PDI Created"; "PDI Created")
                {
                }
                field("Direct Purchase Cost"; "Direct Purchase Cost")
                {
                    Visible = false;
                }
                field("Purchase Discount %"; "Purchase Discount %")
                {
                    Visible = false;
                }
                field("Purchase Discount Amount"; "Purchase Discount Amount")
                {
                    Visible = false;
                }
                field("Purchase Cost Amount"; "Purchase Cost Amount")
                {
                    Visible = false;
                }
            }
            group()
            {
                group()
                {
                    field(TotalAmount; TotalAmount)
                    {
                        Caption = 'Total Sales Amount';
                        Editable = false;
                        QuickEntry = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Option)
            {
                Caption = 'Option';
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;

                    trigger OnAction()
                    var
                        recOptTransl: Record "25006375";
                    begin
                        TESTFIELD("Option Code");
                        IF NOT (recOptTransl."Option Type" IN [recOptTransl."Option Type"::"Manufacturer Option", recOptTransl."Option Type"::"Own Option"
                        ]) THEN
                            EXIT;
                        recOptTransl.RESET;
                        recOptTransl.SETRANGE("Option Type", "Option Type");
                        recOptTransl.SETRANGE("Make Code", "Make Code");
                        recOptTransl.SETRANGE("Model Code", "Model Code");
                        recOptTransl.SETRANGE("Model Version No.", "Model Version No.");
                        recOptTransl.SETRANGE("Option Code", "Option Code");
                        PAGE.RUNMODAL(PAGE::"Option Translations", recOptTransl);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Refresh)
                {
                    Caption = 'Refresh';
                    Image = Refresh;

                    trigger OnAction()
                    var
                        cuVehOptMgt: Codeunit "25006304";
                    begin
                        TESTFIELD("Serial No.");
                        TESTFIELD("Assembly ID");
                        CLEAR(cuVehOptMgt);
                        cuVehOptMgt.SyncVehAssembly(Rec);
                    end;
                }
                action("<Action1101907046>")
                {
                    Caption = 'Post Own Option';
                    Image = Post;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM(Text002) THEN
                            EXIT;
                        TESTFIELD("Serial No.");
                        TESTFIELD("Assembly ID");
                        //TESTFIELD("Option Code");
                        TESTFIELD(Posted, FALSE);
                        CLEAR(VehOptMgt);
                        VehOptMgt.PutOnOption(Rec);
                    end;
                }
                action("Create &PDI Service Document")
                {
                    Caption = 'Create &PDI Service Document';
                    Image = ServiceAgreement;

                    trigger OnAction()
                    begin
                        VehicleAssembly.RESET;
                        CurrPage.SETSELECTIONFILTER(VehicleAssembly);
                        VehicleOptionMgt.CreatePDIdocFromAssemblyLine(VehicleAssembly);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        TotalAmount := GetTotalAmount;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //23.05.2013 Elva Baltic P15 >>
        IF CheckDuplicates THEN
            ERROR(Text001);
        //23.05.2013 Elva Baltic P15 <<
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //23.05.2013 Elva Baltic P15 >>
        IF CheckDuplicates THEN
            ERROR(Text001);
        //23.05.2013 Elva Baltic P15 <<
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF xRec."Option Type" = xRec."Option Type"::"Vehicle Base" THEN
            "Option Type" := "Option Type"::"Manufacturer Option"
        ELSE
            "Option Type" := xRec."Option Type";
    end;

    trigger OnOpenPage()
    begin
        TotalAmount := GetTotalAmount;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            CLEAR(OptSalesPrDiscMgt);
            OptSalesPrDiscMgt.UpdateSalesLineAmounts(Rec);
            OptSalesPrDiscMgt.UpdatePurchLineAmounts(Rec);
        END;
    end;

    var
        FCY: Code[20];
        FCYRateDate: Date;
        FCYFactor: Decimal;
        OptSalesPrDiscMgt: Codeunit "25006301";
        Text002: Label 'Do you really want to post put-on?';
        VehOptMgt: Codeunit "25006304";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfile: Record "25006067";
        Text100: Label 'You don''t have rights to modify this field.';
        VehicleOptionMgt: Codeunit "25006304";
        VehicleAssembly: Record "25006380";
        TotalAmount: Decimal;
        Text001: Label 'The same Option already exists.';
        UserProfileMgt: Codeunit "25006002";

    [Scope('Internal')]
    procedure GetTotalAmount() RetValue: Decimal
    var
        TempVehicleAssembly: Record "25006380";
        CurrExchRate: Record "330";
        TotalSalesPrice: Decimal;
        TotalSalesDiscAmount: Decimal;
    begin
        TempVehicleAssembly.RESET;
        TempVehicleAssembly.COPYFILTERS(Rec);
        TempVehicleAssembly.SETRANGE("Make Code");
        TempVehicleAssembly.SETRANGE("Model Code");
        TempVehicleAssembly.SETRANGE("Model Version No.");

        TempVehicleAssembly.CALCSUMS(Amount);
        EXIT(TempVehicleAssembly.Amount);
    end;

    [Scope('Internal')]
    procedure SetFCY(CurrencyCode: Code[20]; ExchangeRateDate: Date; CurrencyFactor: Decimal)
    begin
        FCY := CurrencyCode;
        FCYRateDate := ExchangeRateDate;
        FCYFactor := CurrencyFactor;
    end;

    [Scope('Internal')]
    procedure CheckDuplicates(): Boolean
    var
        VehicleAssembly2: Record "25006380";
    begin
        //23.05.2013 Elva Baltic P15
        VehicleAssembly2.RESET;
        VehicleAssembly2.COPYFILTERS(Rec);
        VehicleAssembly2.SETRANGE("Option Type", "Option Type");
        VehicleAssembly2.SETRANGE("Option Subtype", "Option Subtype");
        VehicleAssembly2.SETRANGE("Option Code", "Option Code");
        VehicleAssembly2.SETFILTER(VehicleAssembly2."Line No.", '<>%1', "Line No.");
        EXIT(VehicleAssembly2.FINDFIRST);
    end;
}

