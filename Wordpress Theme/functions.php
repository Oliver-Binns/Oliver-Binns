<?php

add_action( 'wp_enqueue_scripts', 'enqueue_parent_styles' );

function enqueue_parent_styles() {
   wp_enqueue_style( 'parent-style', get_template_directory_uri().'/style.css' );
}

add_action('wp_head', 'wpse_43672_wp_head');
function wpse_43672_wp_head(){
    //Close PHP tags 
    ?>
	<meta name="apple-itunes-app" content="app-id=1535326851, app-clip-bundle-id=uk.co.oliverbinns.oliverbinns.clip">
	<link href="https://fonts.googleapis.com/css?family=Quicksand:300,400,600,700" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,900;1,400;1,600;1,900&display=swap" rel="stylesheet">
    <?php //Open PHP tags
}

add_filter( 'mkaz_code_syntax_default_lang', function() { return 'swift'; });

/**
 * Prints HTML with meta information for the current post-date/time and author.
 */
function lodestar_posted_on() {
        // Let's get a nicely formatted string for the published date
        $time_string = '<time class="entry-date published updated" datetime="%1$s">%2$s</time>';
        if ( get_the_time( 'U' ) !== get_the_modified_time( 'U' ) ) {
                $time_string = '<time class="entry-date published" datetime="%1$s">%2$s</time><time class="updated" datetime="%3$s">%4$s</time>';
        }

        $time_string = sprintf( $time_string,
                esc_attr( get_the_date( 'c' ) ),
                esc_html( get_the_date() ),
                esc_attr( get_the_modified_date( 'c' ) ),
                esc_html( get_the_modified_date() )
        );

        // Wrap that in a link, and preface it with 'Posted on'
        $posted_on = sprintf(
                esc_html_x( 'Posted on %s', 'post date', 'lodestar' ),
                '<a href="' . esc_url( get_permalink() ) . '" rel="bookmark">' . $time_string . '</a>'
        );

        // Finally, let's write all of this to the page
        echo '<span class="posted-on">' . $posted_on . '</span>';
}
