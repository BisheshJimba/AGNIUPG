tableextension 50191 tableextension50191 extends "IC Outbox Sales Line"
{
    fields
    {
        modify("IC Partner Reference")
        {
            TableRelation = IF (IC Partner Ref. Type=CONST(" ")) "Standard Text"
                            ELSE IF (IC Partner Ref. Type=CONST(G/L Account)) "IC G/L Account"
                            ELSE IF (IC Partner Ref. Type=CONST(Item)) Item
                            ELSE IF (IC Partner Ref. Type=CONST("Charge (Item)")) "Item Charge"
                            ELSE IF (IC Partner Ref. Type=CONST(Cross reference)) "Item Cross Reference";
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";
        }
        field(25006373; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = Normal;
        }
        field(25006386; "Vehicle Body Colour Code"; Code[10])
        {
            Caption = 'Vehicle Body Colour Code';
            TableRelation = "Body Color";
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
    }
}

