import QtQuick

Rectangle {
    enum State_1 { State_1_morehalf, State_1_almosthalf, State_1_barelyhal}

    id: progressBar

    property alias shapeHeight: shape.height
    property alias shapeRadius: shape.radius
    property alias shapeWidth: shape.width

    property int _state: ProgressBar_2.State_1.State_1_morehalf

    height: 4
    width: 267

    clip: true
    color: "#a1a1a1"
    radius: 2

    states: [
        State {
            name: "state=morehalf"
            when: progressBar._state === ProgressBar_2.State_1.State_1_morehalf
    
            PropertyChanges {
                width: 146
    
                target: shape
            }
            PropertyChanges {
                color: "#5186f8"
                target: shape
            }
        },
        State {
            name: "state=almosthalf"
            when: progressBar._state === ProgressBar_2.State_1.State_1_almosthalf
    
            PropertyChanges {
                width: 120
    
                target: shape
            }
            PropertyChanges {
                color: "#f8cb51"
                target: shape
            }
        },
        State {
            name: "state=barelyhal"
            when: progressBar._state === ProgressBar_2.State_1.State_1_barelyhal
    
            PropertyChanges {
                width: 33
    
                target: shape
            }
            PropertyChanges {
                color: "#f85151"
                target: shape
            }
        }
    ]

    Rectangle {
        id: shape

        height: 4
        width: 146

        color: "#5186f8"
        radius: 2
    }
}