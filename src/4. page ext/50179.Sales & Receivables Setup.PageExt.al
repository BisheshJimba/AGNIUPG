pageextension 50179 pageextension50179 extends "Sales & Receivables Setup"
{
    // 17.12.2014 EDMS P12
    //   * Open field "Veh. Marg. VAT Item Charge", and property Visible for field "Veh. Marginal VAT Account No." changed from TRUE to False
    // 
    // 20.03.2013 EDMS P8
    //   * Added fields "Vehicle Service Plan on Sales"
    layout
    {
        addafter("Control 37")
        {
            field("Def. Ordering Price Type Code"; Rec."Def. Ordering Price Type Code")
            {
            }
            field("Payment Method Mandatory"; Rec."Payment Method Mandatory")
            {
            }
            field("Item No. Replacement Warnings"; Rec."Item No. Replacement Warnings")
            {
            }
            field("Dimensionwise Cr. Limit Check"; Rec."Dimensionwise Cr. Limit Check")
            {
            }
            field("Enable Sales Synchronization"; Rec."Enable Sales Synchronization")
            {
            }
            field("Auto Apply Replacements"; Rec."Auto Apply Replacements")
            {
            }
            field("Toatl Amt. as Qty-to Ship"; Rec."Toatl Amt. as Qty-to Ship")
            {
            }
            field("Show Description From"; Rec."Show Description From")
            {
            }
            field("External Service VAT Book"; Rec."External Service VAT Book")
            {
            }
        }
        addafter("Control 25")
        {
            field("Contract Nos."; Rec."Contract Nos.")
            {
            }
            field("Veh. Insurance Payment Nos."; Rec."Veh. Insurance Payment Nos.")
            {
            }
            field("Veh. Dispatch No."; Rec."Veh. Dispatch No.")
            {
            }
            field("Commercial Nos."; Rec."Commercial Nos.")
            {
            }
            group(Prices)
            {
                Caption = 'Prices';
                field("Def.S.Price VAT Bus.Post.Grp."; Rec."Def.S.Price VAT Bus.Post.Grp.")
                {
                }
                field("Def.S.Price VAT Prod.Post.Grp."; Rec."Def.S.Price VAT Prod.Post.Grp.")
                {
                }
                field("Def.S.Price Currency Code"; Rec."Def.S.Price Currency Code")
                {
                }
                field("Def.S.Price Rounding Precision"; Rec."Def.S.Price Rounding Precision")
                {
                }
                field("Def. Sales Price Include VAT"; Rec."Def. Sales Price Include VAT")
                {
                }
                field("Def.Sales Price AllowLineDisc."; Rec."Def.Sales Price AllowLineDisc.")
                {
                }
                field("Def.Sales Price Include Disc."; Rec."Def.Sales Price Include Disc.")
                {
                }
                field("Profit % Local Parts"; Rec."Profit % Local Parts")
                {
                }
                field("NDP Factor (%)"; Rec."NDP Factor (%)")
                {
                }
                field("Def. Sales VAT %"; Rec."Def. Sales VAT %")
                {
                }
            }
            group(Vehicles)
            {
                Caption = 'Vehicles';
                field("Trade-In Sales Account No."; Rec."Trade-In Sales Account No.")
                {
                }
                field("Veh. Marginal VAT Account No."; Rec."Veh. Marginal VAT Account No.")
                {
                    Visible = false;
                }
                field("Veh. Marg. VAT Item Charge"; Rec."Veh. Marg. VAT Item Charge")
                {
                }
                field("Veh. Marg.VAT Gen.Bus.Grp."; Rec."Veh. Marg.VAT Gen.Bus.Grp.")
                {
                }
                field("Veh. Marg.VAT Gen.Prod.Grp."; Rec."Veh. Marg.VAT Gen.Prod.Grp.")
                {
                }
                field("Def.Vehicle-Contact Rel."; Rec."Def.Vehicle-Contact Rel.")
                {
                }
                field("Vehicle Sales Item Charge"; Rec."Vehicle Sales Item Charge")
                {
                }
                field("Vehicle Warranty on Sales"; Rec."Vehicle Warranty on Sales")
                {
                }
                field("Compress Prepayment"; Rec."Compress Prepayment")
                {
                }
                field("Custom Application Location 1"; Rec."Custom Application Location 1")
                {
                }
                field("Custom Application Location 2"; Rec."Custom Application Location 2")
                {
                }
                field("Link Relationship Code"; Rec."Link Relationship Code")
                {
                }
                field("Vehicle Allotment Header Text"; Rec."Vehicle Allotment Header Text")
                {
                }
                field("Vehicle Allotment Footer Text1"; Rec."Vehicle Allotment Footer Text1")
                {
                }
                field("Vehicle Allotment Footer Text2"; Rec."Vehicle Allotment Footer Text2")
                {
                }
                field("Vehicle Allocation Due Date"; Rec."Vehicle Allocation Due Date")
                {
                    Caption = 'Vehicle Allocation Due Date (In Days)';
                    Visible = false;
                }
                field("Vehicle Service Plan on Sales"; Rec."Vehicle Service Plan on Sales")
                {
                }
                field("LC Validity Days"; Rec."LC Validity Days")
                {
                }
                field("DO Validity Days"; Rec."DO Validity Days")
                {
                }
                field("Tender Validity Days"; Rec."Tender Validity Days")
                {
                }
                field("Agni Corporate Location"; Rec."Agni Corporate Location")
                {
                }
                field("Purchase Account"; Rec."Purchase Account")
                {
                }
                field("LC Vendor A/c"; Rec."LC Vendor A/c")
                {
                }
                field("Goods In Transit A/c"; Rec."Goods In Transit A/c")
                {
                }
                field("Bills on LC A/c"; Rec."Bills on LC A/c")
                {
                }
                field("Dispatch Template Name"; Rec."Dispatch Template Name")
                {
                }
                field("Dispatch Batch Name"; Rec."Dispatch Batch Name")
                {
                }
            }
            group(Accessories)
            {
                Caption = 'Accessories';
                field("Accessories Issue No. Series"; Rec."Accessories Issue No. Series")
                {
                }
                field("Accessories CVD Account"; Rec."Accessories CVD Account")
                {
                }
                field("Accessories PCD Account"; Rec."Accessories PCD Account")
                {
                }
            }
            group("Customer Set Up")
            {
                Caption = 'Customer Set Up';
                field("Def. Taxable VAT Bus. Code"; Rec."Def. Taxable VAT Bus. Code")
                {
                    Caption = 'Def. Taxable VAT Bus. Code';
                }
                field("Def. NonTaxable VAT Bus. Code"; Rec."Def. NonTaxable VAT Bus. Code")
                {
                }
                field("Activate SMS System"; Rec."Activate SMS System")
                {
                }
            }
            group("Agni Aastha Company")
            {
                Caption = 'Agni Aastha Company';
                Visible = ShowAgniAsthaCompany;
                field("Margin Percentage"; Rec."Margin Percentage")
                {
                    Editable = EditAgniAstha;
                    Visible = false;
                }
                field("Interest Percentage"; Rec."Interest Percentage")
                {
                    Editable = EditAgniAstha;
                }
                field("Interest Calculate Days"; Rec."Interest Calculate Days")
                {
                    Editable = EditAgniAstha;
                }
            }
        }
        addafter("Control 2")
        {
            group("QR Code")
            {
                Caption = 'QR Code';
                field("QR Code"; Rec."QR Code")
                {
                }
            }
        }
    }

    var
        ShowAgniAsthaCompany: Boolean;
        CompanyInformation: Record "79";
        UserSetup: Record "91";
        EditAgniAstha: Boolean;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    //Amisha 5/13/2021
    CompanyInformation.GET;
    IF CompanyInformation."Agni Astha Company" THEN
      ShowAgniAsthaCompany := TRUE;

    UserSetup.GET(USERID);
    IF UserSetup."Can Edit Margin Interest Rate" THEN
      EditAgniAstha := TRUE;
    */
    //end;
}

