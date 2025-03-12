import { jsx as _jsx } from "react/jsx-runtime";
import { useParams } from "react-router-dom";
import ReactPlayer from "react-player";
import './Trailer.css';
const Trailer = () => {
    let params = useParams();
    let key = params.ytTrailerId;
    return (_jsx("div", { className: "react-player-container", children: (key != null) ? _jsx(ReactPlayer, { controls: true, playing: true, url: `https://www.youtube.com/embed/${key}`, width: '100%', height: '100%', config: {
                youtube: {
                    playerVars: { showinfo: 0, modestbranding: 1, origin: window.location.origin }
                }
            } }) : null }));
};
export default Trailer;
