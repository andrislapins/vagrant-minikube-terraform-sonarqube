package com.andrefeuille.movies;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/movies")
@CrossOrigin(origins = "*")
public class MovieController {

    private static final Logger logger = LoggerFactory.getLogger(MovieController.class);

    @Autowired
    private MovieService movieService;

    @GetMapping
    public ResponseEntity<List<Movie>> getAllMovies() {
        logger.info("Fetching all movies");
        List<Movie> movies = movieService.allMovies();
        logger.info("Found {} movies", movies.size());
        return new ResponseEntity<>(movies, HttpStatus.OK);
    }

    @GetMapping("/{imdbId}")
    public ResponseEntity<Optional<Movie>> getSingleMovie(@PathVariable String imdbId) {
        logger.info("Fetching movie with imdbId: {}", imdbId);
        Optional<Movie> movie = movieService.singleMovie(imdbId);
        if (movie.isPresent()) {
            logger.info("Found movie with imdbId: {}", imdbId);
        } else {
            logger.info("Movie with imdbId: {} not found", imdbId);
        }
        return new ResponseEntity<>(movie, HttpStatus.OK);
    }
}