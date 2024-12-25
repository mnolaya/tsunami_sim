// typedef struct c_SimParams{
//     int icenter;
//     int grid_size;
//     int timesteps;
//     double dt;
//     double dx;
//     double c;
//     double decay;
// } c_SimParams;

// // void c_run_solver(int *icenter, int *grid_size, int *timesteps, double *dt, double *dx, double *c, double *decay, double *h);
// void c_run_solver(void *c_SimParams, double *h);

int f_validate_sim_params(int *grid_size, double *dt, double *dx, double *c);

double f_finite_diff_center(double *x, double *dx, int *n);

double f_gauss_init(int *grid_size, double *decay, int *icenter, double *h);
