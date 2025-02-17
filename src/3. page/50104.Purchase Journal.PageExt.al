pageextension 50104 pageextension50104 extends "Purchase Journal"
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 1001")
        {
            field(Narration; Narration)
            {
            }
        }
        addafter("Control 79")
        {
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
        }
    }
}

