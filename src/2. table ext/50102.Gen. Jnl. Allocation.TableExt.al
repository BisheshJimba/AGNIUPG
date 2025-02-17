tableextension 50102 tableextension50102 extends "Gen. Jnl. Allocation"
{
    fields
    {
        modify("Journal Line No.")
        {
            TableRelation = "Gen. Journal Line"."Line No." WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                  "Journal Batch Name" = FIELD("Journal Batch Name"));
        }
        field(481; "Document Class"; Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";

            trigger OnValidate()
            begin
                //chandra 01.09.2015 to avoid errors e.g. if user select vendor in document class after selecting Customer No. in Document subclass
                VALIDATE("Document Subclass", '');
            end;
        }
        field(482; "Document Subclass"; Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF ("Document Class" = CONST(Customer)) Customer
            ELSE IF ("Document Class" = CONST(Vendor)) Vendor
            ELSE IF ("Document Class" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Document Class" = CONST("Fixed Assets")) "Fixed Asset";
        }
    }
}

