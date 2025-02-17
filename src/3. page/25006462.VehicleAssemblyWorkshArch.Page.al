page 25006462 "Vehicle Assembly Worksh. Arch."
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified Amount - OnValidate(), Usert Profile Setup to Branch Profile Setup
    //   Modified Sales Price - OnValidate(), Usert Profile Setup to Branch Profile Setup

    AutoSplitKey = true;
    Caption = 'Vehicle Assembly Worksh. Arch.';
    DataCaptionFields = "Assembly ID", "Line No.", "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = Table25006384;

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
                    Visible = false;
                }
                field("Option Code"; "Option Code")
                {
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
                field("Cost Amount"; "Cost Amount")
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
            }
            group()
            {
                group()
                {
                    field(GetTotalAmount; GetTotalAmount)
                    {
                        Caption = 'Total Sales Amount';
                        Editable = false;
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
        }
    }

    trigger OnClosePage()
    begin
        CLEAR(OptSalesPrDiscMgt);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF xRec."Option Type" = xRec."Option Type"::"Vehicle Base" THEN
            "Option Type" := "Option Type"::"Manufacturer Option"
        ELSE
            "Option Type" := xRec."Option Type";
    end;

    var
        FCY: Code[20];
        FCYRateDate: Date;
        FCYFactor: Decimal;
        OptSalesPrDiscMgt: Codeunit "25006301";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfile: Record "25006067";
        Text100: Label 'You don''t have rights to modify this field.';
        VehicleAssembly: Record "25006384";
        UserProfileMgt: Codeunit "25006002";

    [Scope('Internal')]
    procedure GetTotalAmount(): Decimal
    var
        TempVehicleAssembly: Record "25006384";
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
}

