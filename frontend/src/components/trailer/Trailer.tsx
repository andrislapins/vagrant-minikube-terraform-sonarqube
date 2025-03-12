
import { useParams } from "react-router-dom";
import ReactPlayer from "react-player";
import './Trailer.css'

import React from 'react'

const Trailer = () => {

    let params = useParams();
    let key = params.ytTrailerId;

  return (
    <div className="react-player-container">
        { 
          (key != null) ? <ReactPlayer
                              controls={true}
                              playing={true}
                              url={`https://www.youtube.com/embed/${key}`}
                              width='100%' 
                              height='100%'
                              config={{
                                youtube: {
                                  playerVars: { showinfo: 0, modestbranding: 1, origin: window.location.origin }
                                }
                              }} 
                          /> : null
        }
    </div>
  )
}

export default Trailer