page 33019801 "KSKL Setup"
{
    CardPageID = "KSKL Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33019801;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'KSKL';
                field("Identification Number"; "Identification Number")
                {
                    ShowMandatory = true;
                }
                field("Branch Id"; "Branch Id")
                {
                }
                field("Skiping Payment Flag"; "Skiping Payment Flag")
                {
                }
                field("Skip VR and VS"; "Skip VR and VS")
                {
                }
                field("Previous Branch Id"; "Previous Branch Id")
                {
                }
                field("Closed Loan"; "Closed Loan")
                {
                }
            }
            group("General Commercial")
            {
                Caption = 'For Commercial';
                field("Segment Identifier HD"; "Segment Identifier HD")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier CF"; "Segment Identifier CF")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier CH"; "Segment Identifier CH")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier CS"; "Segment Identifier CS")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier RS"; "Segment Identifier RS")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier BR"; "Segment Identifier BR")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier SS"; "Segment Identifier SS")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier VS"; "Segment Identifier VS")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier VR"; "Segment Identifier VR")
                {
                    ShowMandatory = true;
                }
                field("Segment Identifier TL"; "Segment Identifier TL")
                {
                    ShowMandatory = true;
                }
            }
            group("For Consumer")
            {
                Caption = 'For Consumer';
                field("Consumer Segment Identifier HD"; "Consumer Segment Identifier HD")
                {
                    Caption = 'Segment Identifier HD';
                }
                field("Consumer Segment Identifier CF"; "Consumer Segment Identifier CF")
                {
                    Caption = 'Segment Identifier CF';
                }
                field("Consumer Segment Identifier CH"; "Consumer Segment Identifier CH")
                {
                    Caption = 'Segment Identifier CH';
                }
                field("Consumer Segment Identifier CS"; "Consumer Segment Identifier CS")
                {
                    Caption = 'Segment Identifier CS';
                }
                field("Consumer Segment Identifier ES"; "Consumer Segment Identifier ES")
                {
                    Caption = 'Segment Identifier ES';
                }
                field("Consumer Segment Identifier RS"; "Consumer Segment Identifier RS")
                {
                    Caption = 'Segment Identifier RS';
                }
                field("Consumer Segment Identifier BR"; "Consumer Segment Identifier BR")
                {
                    Caption = 'Segment Identifier BR';
                }
                field("Consumer Segment Identifier SS"; "Consumer Segment Identifier SS")
                {
                    Caption = 'Segment Identifier SS';
                }
                field("Consumer Segment Identifier VS"; "Consumer Segment Identifier VS")
                {
                    Caption = 'Segment Identifier VS';
                }
                field("Consumer Segment Identifier VR"; "Consumer Segment Identifier VR")
                {
                    Caption = 'Segment Identifier VR';
                }
                field("Consumer Segment Identifier TL"; "Consumer Segment Identifier TL")
                {
                    Caption = 'Segment Identifier TL';
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field("Nature of Data(Commercial)"; "Nature of Data(Commercial)")
                {
                }
                field("Nature of Data(Consumer)"; "Nature of Data(Consumer)")
                {
                    ShowMandatory = true;
                }
                field("File Path"; "File Path")
                {
                }
                field("Prev Identification Number"; "Prev Identification Number")
                {
                }
                field("IFF Version ID(Commercial)"; "IFF Version ID(Commercial)")
                {
                }
                field("IFF Version ID(Consumer)"; "IFF Version ID(Consumer)")
                {
                    ShowMandatory = true;
                }
            }
            group("No Series")
            {
                Caption = 'No Series';
                field("Customer RE Number"; "Customer RE Number")
                {
                    Caption = 'Customer Related Entity Number';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;
}

