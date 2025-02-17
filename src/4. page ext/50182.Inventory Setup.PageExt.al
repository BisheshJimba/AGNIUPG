pageextension 50182 pageextension50182 extends "Inventory Setup"
{
    // 21.01.2015 EDMS P11
    //   Vehicle Special Costing
    //   Added fields:
    //     25006040 "Vehicle Special Costing" [boolean]
    //     25006050 "Vehicle Original Cost Date" [boolean]
    layout
    {
        addafter("Control 3")
        {
            field("Def. Model Version Item Cat."; Rec."Def. Model Version Item Cat.")
            {
            }
            field("Post Veh. Add. Charges on Sale"; Rec."Post Veh. Add. Charges on Sale")
            {
            }
            field("Vehicle Special Costing"; Rec."Vehicle Special Costing")
            {
            }
            field("Vehicle Original Cost Date"; Rec."Vehicle Original Cost Date")
            {
            }
        }
        addafter("Control 34")
        {
            field("Fill Item Group Def. Dimension"; Rec."Fill Item Group Def. Dimension")
            {
            }
        }
        addafter("Control 32")
        {
            field("CVD Insurance Memo Nos."; Rec."CVD Insurance Memo Nos.")
            {
            }
            field("PCD Insurance Memo Nos."; Rec."PCD Insurance Memo Nos.")
            {
            }
            field("CVD CC Memo Nos."; Rec."CVD CC Memo Nos.")
            {
            }
            field("PCD CC Memo Nos."; Rec."PCD CC Memo Nos.")
            {
            }
            group(Vehicles)
            {
                Caption = 'Vehicles';
                field("Vehicle Serial No. Nos."; Rec."Vehicle Serial No. Nos.")
                {
                }
                field("Vehicle Acc. Cycle Nos."; Rec."Vehicle Acc. Cycle Nos.")
                {
                }
                field("Vehicle Assembly Nos."; Rec."Vehicle Assembly Nos.")
                {
                }
                field("Vehicle Assembly Document Nos."; Rec."Vehicle Assembly Document Nos.")
                {
                }
            }
        }
        addafter("Control 1904569201")
        {
            group("Procurement Setup")
            {
                Caption = 'Procurement Setup';
                field("Item Journal Template"; Rec."Item Journal Template")
                {
                }
                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                }
                field("Item Reclass. Journal Template"; Rec."Item Reclass. Journal Template")
                {
                }
                field("Item Reclass. Journal Batch"; Rec."Item Reclass. Journal Batch")
                {
                }
            }
            group(QR)
            {
                field("Default Old Lot No."; Rec."Default Old Lot No.")
                {
                }
                field("QR Item Reclass Jnl. Template"; Rec."QR Item Reclass Jnl. Template")
                {
                }
                field("QR Item Reclass Jnl. Batch"; Rec."QR Item Reclass Jnl. Batch")
                {
                }
            }
            group("HS Code Format")
            {
                Caption = 'HS Code Format';
                field("HS Code Format"; Rec."HS Code Format")
                {
                }
                field("HS Code Prefix Length"; Rec."HS Code Prefix Length")
                {
                }
            }
        }
    }
}

