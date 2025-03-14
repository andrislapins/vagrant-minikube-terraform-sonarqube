
import './Hero.css';
import Carousel from 'react-material-ui-carousel';
import { Paper } from '@mui/material';
import { faCirclePlay } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Link, useNavigate } from 'react-router-dom';
import { Button } from 'react-bootstrap';


const Hero = ({ movies }) => {

  const navigate = useNavigate();

  function reviews(movieId) {
    navigate(`/Reviews/${movieId}`);
  }

  // https://stackoverflow.com/questions/77734858/warning-internal-react-error-expected-static-flag-was-missing-please-notify-t
  // Such conditionals have to be put after every hook in the component.  
  if (!movies || movies.length === 0) {
    return <p>Loading movies...</p>;
  }

  return (
    <div className='movie-carousel-container'>
        <Carousel>
            {
                movies.map(((movie, index) => {
                    return (
                        <Paper key={ movie.imdbId || index }>
                            <div className='movie-card-container'>
                              <div className="movie-card" style={{"--img": `url(${movie.backdrops?.[0] || ''})` }}>
                                    <div className='movie-detail'>
                                        <div className='movie-poster'>
                                            <img src={movie.poster} alt="" />
                                        </div>
                                        <div className='movie-title'>
                                            <h4>{movie.title}</h4>
                                        </div>
                                        <div className='movie-buttons-container'>
                                            <Link to={movie.trailerLink ? `/Trailer/${movie.trailerLink.slice(32)}` : '#' }>    
                                                <div className='play-button-icon-container'>
                                                    <FontAwesomeIcon className="play-button-icon"
                                                        icon={faCirclePlay}
                                                    />
                                                </div>
                                            </Link>
                                            <div className='movie-review-button-container'>
                                                <Button variant='info' onClick={() => reviews(movie.imdbId)}>Reviews</Button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </Paper>
                    )
                }))
            }
        </Carousel>
    </div>
  )
}

export default Hero