tableextension 50153 tableextension50153 extends "Inventory Setup"
{
    // 21.01.2015 EDMS P11
    //   Vehicle Special Costing
    //   Added fields:
    //     25006040 "Vehicle Special Costing" [boolean]
    //     25006050 "Vehicle Original Cost Date" [boolean]
    // 
    // 10.05.2007 Elva Baltic P2
    //   *Add field "Use Item Category Dim."
    fields
    {
        field(50000; "Inward Gate Entry Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50001; "Outward Gate Entry Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(70000; "Default Old Lot No."; Code[20])
        {
            Description = 'QR19.00';
        }
        field(70002; "QR Item Reclass Jnl. Template"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(70003; "QR Item Reclass Jnl. Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE(Journal Template Name=FIELD(QR Item Reclass Jnl. Template));
        }
        field(70005; "HS Code Format"; Code[20])
        {
        }
        field(70006; "HS Code Prefix Length"; Integer)
        {
        }
        field(25006000; "Vehicle Assembly Nos."; Code[10])
        {
            Caption = 'Vehicle Assembly Nos.';
            TableRelation = "No. Series";
        }
        field(25006001; "Vehicle Serial No. Nos."; Code[10])
        {
            Caption = 'Vehicle Serial No. Nos.';
            TableRelation = "No. Series";
        }
        field(25006002; "Vehicle Acc. Cycle Nos."; Code[10])
        {
            Caption = 'Vehicle Acc. Cycle Nos.';
            TableRelation = "No. Series";
        }
        field(25006005; "Fill Item Group Def. Dimension"; Boolean)
        {
            Caption = 'Fill Item Group Def. Dimension';
        }
        field(25006010; "Post Veh. Add. Charges on Sale"; Boolean)
        {
            Caption = 'Post Vehicle Additional Charges on Sale';

            trigger OnValidate()
            begin
                IF "Post Veh. Add. Charges on Sale" <> xRec."Post Veh. Add. Charges on Sale" THEN BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETCURRENTKEY("Item Type");
                    ItemLedgEntry.SETRANGE("Item Type", ItemLedgEntry."Item Type"::"Model Version");
                    IF ItemLedgEntry.FINDFIRST THEN ERROR(Text100, ItemLedgEntry.TABLECAPTION)
                END;
            end;
        }
        field(25006020; "Vehicle Assembly Document Nos."; Code[10])
        {
            Caption = 'Vehicle Assembly Document Nos.';
            TableRelation = "No. Series";
        }
        field(25006030; "Def. Model Version Item Cat."; Code[10])
        {
            Caption = 'Def. Model Version Item Category';
            TableRelation = "Item Category";
        }
        field(25006040; "Vehicle Special Costing"; Boolean)
        {
            Caption = 'Vehicle Special Costing';
        }
        field(25006050; "Vehicle Original Cost Date"; Boolean)
        {
            Caption = 'Vehicle Original Cost Date';
        }
        field(33019810; "Item Journal Template"; Code[10])
        {
        }
        field(33019811; "Item Journal Batch"; Code[10])
        {
        }
        field(33019812; "Item Reclass. Journal Template"; Code[10])
        {
        }
        field(33019813; "Item Reclass. Journal Batch"; Code[10])
        {
        }
        field(33020163; "CVD Insurance Memo Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020164; "PCD Insurance Memo Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020165; "CVD CC Memo Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33020166; "PCD CC Memo Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    var
        Text100: Label 'There are records in Table %1.';
}

